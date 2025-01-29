from PySide6.QtWidgets import *
from PySide6.QtCore import *
import psutil
import platform
from datetime import datetime
import plotly.graph_objs as go
from plotly.subplots import make_subplots

class SystemMonitorTab(QWidget):
    def __init__(self):
        super().__init__()
        self.setup_ui()
        
        # Initialize data storage for graphs
        self.cpu_history = []
        self.memory_history = []
        self.timestamps = []
        
        # Setup update timer
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_stats)
        self.timer.start(1000)  # Update every second
        
    def setup_ui(self):
        layout = QVBoxLayout(self)
        
        # Create top section with current stats
        stats_group = QGroupBox("System Statistics")
        stats_layout = QGridLayout()
        
        # CPU Usage
        self.cpu_bar = QProgressBar()
        stats_layout.addWidget(QLabel("CPU Usage:"), 0, 0)
        stats_layout.addWidget(self.cpu_bar, 0, 1)
        
        # Memory Usage
        self.memory_bar = QProgressBar()
        stats_layout.addWidget(QLabel("Memory Usage:"), 1, 0)
        stats_layout.addWidget(self.memory_bar, 1, 1)
        
        # Disk Usage
        self.disk_bar = QProgressBar()
        stats_layout.addWidget(QLabel("Disk Usage:"), 2, 0)
        stats_layout.addWidget(self.disk_bar, 2, 1)
        
        stats_group.setLayout(stats_layout)
        layout.addWidget(stats_group)
        
        # Create process table
        process_group = QGroupBox("Running Processes")
        process_layout = QVBoxLayout()
        
        self.process_table = QTableWidget()
        self.process_table.setColumnCount(5)
        self.process_table.setHorizontalHeaderLabels([
            "PID", "Name", "CPU %", "Memory %", "Status"
        ])
        
        process_layout.addWidget(self.process_table)
        process_group.setLayout(process_layout)
        layout.addWidget(process_group)
        
        # Add refresh button
        refresh_btn = QPushButton("Refresh")
        refresh_btn.clicked.connect(self.refresh)
        layout.addWidget(refresh_btn)
        
    def update_stats(self):
        # Update CPU usage
        cpu_percent = psutil.cpu_percent()
        self.cpu_bar.setValue(int(cpu_percent))
        
        # Update memory usage
        memory = psutil.virtual_memory()
        self.memory_bar.setValue(int(memory.percent))
        
        # Update disk usage
        disk = psutil.disk_usage('/')
        self.disk_bar.setValue(int(disk.percent))
        
        # Update process table
        self.update_process_table()
        
        # Store historical data
        self.timestamps.append(datetime.now())
        self.cpu_history.append(cpu_percent)
        self.memory_history.append(memory.percent)
        
        # Keep only last hour of data
        max_points = 3600
        if len(self.timestamps) > max_points:
            self.timestamps = self.timestamps[-max_points:]
            self.cpu_history = self.cpu_history[-max_points:]
            self.memory_history = self.memory_history[-max_points:]
            
    def update_process_table(self):
        processes = []
        for proc in psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent', 'status']):
            try:
                pinfo = proc.info
                processes.append(pinfo)
            except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
                pass
                
        # Sort by CPU usage
        processes.sort(key=lambda x: x['cpu_percent'], reverse=True)
        
        # Update table
        self.process_table.setRowCount(len(processes))
        for i, proc in enumerate(processes):
            self.process_table.setItem(i, 0, QTableWidgetItem(str(proc['pid'])))
            self.process_table.setItem(i, 1, QTableWidgetItem(proc['name']))
            self.process_table.setItem(i, 2, QTableWidgetItem(f"{proc['cpu_percent']:.1f}"))
            self.process_table.setItem(i, 3, QTableWidgetItem(f"{proc.get('memory_percent', 0):.1f}"))
            self.process_table.setItem(i, 4, QTableWidgetItem(proc['status']))
            
    def refresh(self):
        self.update_stats()
