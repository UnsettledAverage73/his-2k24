from PySide6.QtWidgets import (QWidget, QVBoxLayout, QGroupBox, QGridLayout, 
                             QLabel, QProgressBar, QTableWidget, QPushButton,
                             QTableWidgetItem)
from PySide6.QtCore import QTimer
import psutil
from datetime import datetime

class SystemMonitorTab(QWidget):
    def __init__(self):
        super().__init__()
        self.setup_ui()
        
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
        self.process_table = QTableWidget()
        self.process_table.setColumnCount(5)
        self.process_table.setHorizontalHeaderLabels([
            "PID", "Name", "CPU %", "Memory %", "Status"
        ])
        layout.addWidget(self.process_table)
        
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
        self.process_table.setRowCount(len(processes[:10]))  # Show top 10 processes
        for i, proc in enumerate(processes[:10]):
            self.process_table.setItem(i, 0, QTableWidgetItem(str(proc['pid'])))
            self.process_table.setItem(i, 1, QTableWidgetItem(proc['name']))
            self.process_table.setItem(i, 2, QTableWidgetItem(f"{proc['cpu_percent']:.1f}"))
            self.process_table.setItem(i, 3, QTableWidgetItem(f"{proc.get('memory_percent', 0):.1f}"))
            self.process_table.setItem(i, 4, QTableWidgetItem(proc['status']))
            
    def refresh(self):
        self.update_stats()
