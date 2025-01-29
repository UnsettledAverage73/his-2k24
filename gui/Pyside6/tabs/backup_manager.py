from PySide6.QtWidgets import (QWidget, QVBoxLayout, QPushButton, QTextEdit,
                             QTableWidget, QTableWidgetItem, QLabel)
from pathlib import Path
import shutil
import datetime
import logging

class BackupManagerTab(QWidget):
    def __init__(self):
        super().__init__()
        self.setup_ui()
        
    def setup_ui(self):
        layout = QVBoxLayout(self)
        
        # Backup status display
        self.status_display = QTextEdit()
        self.status_display.setReadOnly(True)
        layout.addWidget(QLabel("Backup Status:"))
        layout.addWidget(self.status_display)
        
        # Backup button
        self.backup_button = QPushButton("Create Backup")
        self.backup_button.clicked.connect(self.create_backup)
        layout.addWidget(self.backup_button)
        
        # Backup history table
        self.history_table = QTableWidget()
        self.history_table.setColumnCount(3)
        self.history_table.setHorizontalHeaderLabels(["Date", "Size", "Status"])
        layout.addWidget(QLabel("Backup History:"))
        layout.addWidget(self.history_table)
        
        self.refresh()
        
    def create_backup(self):
        try:
            backup_dir = Path("backups")
            backup_dir.mkdir(exist_ok=True)
            
            timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_path = backup_dir / f"backup_{timestamp}"
            
            # Create backup here - example just creates an empty directory
            backup_path.mkdir()
            
            self.status_display.append(f"Backup created at {backup_path}")
            self.refresh()
            
        except Exception as e:
            error_msg = f"Backup failed: {str(e)}"
            self.status_display.append(error_msg)
            logging.error(error_msg)
            
    def refresh(self):
        try:
            backup_dir = Path("backups")
            if not backup_dir.exists():
                return
                
            backups = list(backup_dir.glob("backup_*"))
            self.history_table.setRowCount(len(backups))
            
            for i, backup in enumerate(backups):
                date = datetime.datetime.fromtimestamp(backup.stat().st_mtime)
                size = backup.stat().st_size
                
                self.history_table.setItem(i, 0, QTableWidgetItem(date.strftime("%Y-%m-%d %H:%M:%S")))
                self.history_table.setItem(i, 1, QTableWidgetItem(f"{size/1024:.1f} KB"))
                self.history_table.setItem(i, 2, QTableWidgetItem("Complete"))
                
        except Exception as e:
            error_msg = f"Error refreshing backup history: {str(e)}"
            self.status_display.append(error_msg)
            logging.error(error_msg)
