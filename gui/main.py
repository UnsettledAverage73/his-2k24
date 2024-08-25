import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import threading
import subprocess
import platform

# Function to execute the script
def execute_script(script_name, execution_label, output_text, progress_bar):
    try:
        execution_label.config(text=f"Execution started for {script_name}")

        if platform.system() == "Windows":
            process = subprocess.Popen([script_name], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, text=True)
        else:  # Assume Linux/Unix
            process = subprocess.Popen(["bash", script_name], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        progress = 0
        while True:
            output = process.stdout.readline()
            if output == "" and process.poll() is not None:
                break
            if output:
                output_text.insert(tk.END, output)
                output_text.see(tk.END)
                progress += 1
                progress_bar['value'] = (progress % 100) + 1  # Simulate progress bar
                output_text.update_idletasks()

        stderr_output = process.stderr.read()
        if stderr_output:
            output_text.insert(tk.END, stderr_output)
            output_text.see(tk.END)
            result = False
        else:
            result = True

        process.stdout.close()
        process.stderr.close()

        if result:
            execution_label.config(text="Execution completed successfully")
        else:
            execution_label.config(text="Execution completed with errors")

        progress_bar['value'] = 0  # Reset progress bar
        messagebox.showinfo("Execution Complete", f"{script_name} finished with return code {process.returncode}")
    except Exception as e:
        execution_label.config(text="Execution failed")
        messagebox.showerror("Error", f"Error occurred while running {script_name}: {str(e)}")

# Function to trigger script execution
def on_execute_button_click(execution_label, output_text, progress_bar):
    selected_script = script_combobox.get()
    if not selected_script:
        messagebox.showwarning("No Script Selected", "Please select a script to execute.")
        return

    output_text.delete(1.0, tk.END)  # Clear previous output
    threading.Thread(target=execute_script, args=(selected_script, execution_label, output_text, progress_bar)).start()

# Function to add a script to the dropdown list
def add_script():
    script_file = filedialog.askopenfilename(
        title="Select a Script", 
        filetypes=[
            ("All Files", "*.*")
        ]
    )
    if script_file:
        # Add the selected script file to the dropdown list
        script_combobox['values'] = (*script_combobox['values'], script_file)
        script_combobox.set(script_file)  # Automatically select the added script

# Function to create tooltips
def create_tooltip(widget, text):
    tooltip = tk.Toplevel(widget)
    tooltip.wm_overrideredirect(True)
    tooltip.withdraw()
    tooltip_label = tk.Label(tooltip, text=text, background="yellow", relief='solid', borderwidth=1)
    tooltip_label.pack()

    def enter(event):
        x, y, cx, cy = widget.bbox("insert")
        x = x + widget.winfo_rootx() + 25
        y = y + widget.winfo_rooty() + 25
        tooltip.wm_geometry(f"+{x}+{y}")
        tooltip.deiconify()

    def leave(event):
        tooltip.withdraw()

    widget.bind('<Enter>', enter)
    widget.bind('<Leave>', leave)

# Create the main window
root = tk.Tk()
root.title("Script Execution GUI")
root.geometry("800x500")

# Customizing the style to mimic Kali Linux terminal
style = ttk.Style()
style.configure("TButton", font=("Consolas", 12), foreground="white", background="black")
style.configure("TLabel", font=("Consolas", 12), foreground="white", background="black")
style.configure("TFrame", background="black")
style.configure("TCombobox", font=("Consolas", 12), foreground="white", background="black")
style.configure("TText", font=("Consolas", 10), foreground="white", background="black")
style.configure("Horizontal.TProgressbar", troughcolor='black', background='green')

# Left section for script selection
left_frame = ttk.Frame(root, padding=10, style="TFrame")
left_frame.grid(row=0, column=0, sticky="nswe", padx=10, pady=10)

# Dropdown for script selection
script_combobox = ttk.Combobox(left_frame, values=[], font=("Consolas", 12), state="readonly")
script_combobox.pack(pady=5)
script_combobox.set("Select a script or add one")

# Add script button
add_button = ttk.Button(left_frame, text="Add Script", command=add_script)
add_button.pack(pady=5)
create_tooltip(add_button, "Click to add a script to the dropdown list")

# Execution button
execute_button = ttk.Button(left_frame, text="Execute Script", command=lambda: on_execute_button_click(execution_label, output_text, progress_bar))
execute_button.pack(pady=10)
create_tooltip(execute_button, "Click to execute the selected script")

# Right section for execution and results
right_frame = ttk.Frame(root, padding=10, style="TFrame")
right_frame.grid(row=0, column=1, sticky="nsew", padx=10, pady=10)

# Label to display execution aspects
execution_label = ttk.Label(right_frame, text="Execution aspects", style="TLabel")
execution_label.pack(expand=False, fill="both", pady=10)
create_tooltip(execution_label, "Displays the current status of the script execution")

# Text widget to display real-time output
output_text = tk.Text(right_frame, height=15, wrap='word', bg="black", fg="green", font=("Consolas", 10))
output_text.pack(expand=True, fill="both", pady=10)

# Progress bar
progress_bar = ttk.Progressbar(right_frame, orient="horizontal", mode="determinate", length=300, style="Horizontal.TProgressbar")
progress_bar.pack(pady=20)

# Configure row and column weights
root.grid_columnconfigure(0, weight=1)  # Left frame
root.grid_columnconfigure(1, weight=3)  # Right frame
root.grid_rowconfigure(0, weight=1)     # Both frames are in row 0

# Run the application
root.mainloop()
