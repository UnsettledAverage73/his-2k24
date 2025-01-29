import logging
from datetime import datetime
from pathlib import Path

def setup_logging():
    # Ensure logs directory exists
    logs_dir = Path("scripts")
    logs_dir.mkdir(exist_ok=True)
    
    # Create log filename with timestamp
    log_filename = logs_dir / f"{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.log"
    
    # Configure logging
    logging.basicConfig(
        filename=log_filename,
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )
    
    return log_filename
