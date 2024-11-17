import os
import tkinter as tk
from tkinter import ttk, messagebox
import threading
import subprocess
import platform


class DirectoryNavigator:
    def __init__(self, root):
        self.root = root
        self.root.title("Script Navigator and Executor")
        self.root.geometry("1000x700")
        self.root.configure(bg="black")
        
        # Initialize paths
        self.default_path = os.path.expanduser("~/his-2k24")
        self.current_path = self.default_path
        self.back_stack = []
        self.forward_stack = []

        # Create GUI components
        self.create_gui()

        # Load initial directory
        self.update_directory_view()

    def create_gui(self):
        # Left Frame: Navigation and Scripts
        self.left_frame = tk.Frame(self.root, bg="black", width=300)
        self.left_frame.pack(side="left", fill="y")

        self.folder_path_label = tk.Label(
            self.left_frame, text=f"Current Folder: {self.current_path}", 
            fg="white", bg="black", wraplength=250, anchor="w", justify="left"
        )
        self.folder_path_label.pack(pady=5, padx=5, anchor="w")

        self.script_list_frame = tk.Frame(self.left_frame, bg="black")
        self.script_list_frame.pack(fill="both", expand=True, padx=5)

        # Navigation Buttons
        button_frame = tk.Frame(self.left_frame, bg="black")
        button_frame.pack(fill="x", padx=5, pady=5)

        self.back_button = tk.Button(button_frame, text="⬅ Back", command=self.go_back, state=tk.DISABLED)
        self.back_button.pack(side="left", padx=5)

        self.forward_button = tk.Button(button_frame, text="➡ Forward", command=self.go_forward, state=tk.DISABLED)
        self.forward_button.pack(side="left", padx=5)

        self.refresh_button = tk.Button(button_frame, text="🔄 Refresh", command=self.update_directory_view)
        self.refresh_button.pack(side="left", padx=5)

        # Right Frame: Execution Output
        self.right_frame = tk.Frame(self.root, bg="black")
        self.right_frame.pack(side="right", fill="both", expand=True)

        tk.Label(self.right_frame, text="Execution Output", fg="white", bg="black").pack(pady=5)

        self.execution_label = tk.Label(self.right_frame, text="Execution status", fg="white", bg="black")
        self.execution_label.pack(pady=5)

        self.output_text = tk.Text(self.right_frame, bg="black", fg="white", wrap="word")
        self.output_text.pack(fill="both", expand=True, padx=5, pady=5)

        # Configure green text tag
        self.output_text.tag_config("green_text", foreground="#00FF00")

        self.progress_bar = ttk.Progressbar(self.right_frame, orient="horizontal", mode="determinate", length=300)
        self.progress_bar.pack(pady=10)

    def update_directory_view(self):
        """Update the list of directories and files."""
        try:
            # Update path label
            self.folder_path_label.config(text=f"Current Folder: {self.current_path}")

            # Clear the old widgets in the script list frame
            for widget in self.script_list_frame.winfo_children():
                widget.destroy()

            # List directories and files
            items = os.listdir(self.current_path)
            if items:
                for item in sorted(items):
                    full_path = os.path.join(self.current_path, item)
                    if os.path.isdir(full_path):
                        # Create a button for navigating into subfolders
                        btn = tk.Button(
                            self.script_list_frame, text=f"[Folder] {item}", bg="black", fg="yellow", relief="flat",
                            command=lambda p=full_path: self.navigate_to(p)
                        )
                        btn.pack(fill="x", padx=5, pady=2)
                    else:
                        # Create a button for executing scripts
                        btn = tk.Button(
                            self.script_list_frame, text=item, bg="black", fg="white", relief="flat",
                            command=lambda p=full_path: threading.Thread(
                                target=self.execute_script, args=(p,)
                            ).start()
                        )
                        btn.pack(fill="x", padx=5, pady=2)
            else:
                tk.Label(self.script_list_frame, text="No files or folders available", fg="white", bg="black").pack()

        except Exception as e:
            messagebox.showerror("Error", f"Unable to load folder contents: {str(e)}")

    def go_back(self):
        """Navigate to the previous path."""
        if self.back_stack:
            self.forward_stack.append(self.current_path)
            self.current_path = self.back_stack.pop()
            self.update_directory_view()
            self.update_buttons()

    def go_forward(self):
        """Navigate to the next path."""
        if self.forward_stack:
            self.back_stack.append(self.current_path)
            self.current_path = self.forward_stack.pop()
            self.update_directory_view()
            self.update_buttons()

    def navigate_to(self, path):
        """Navigate to the specified folder."""
        self.back_stack.append(self.current_path)
        self.current_path = path
        self.forward_stack.clear()
        self.update_directory_view()
        self.update_buttons()

    def execute_script(self, script_path):
        """Execute the selected script."""
        try:
            # Clear previous output
            self.output_text.delete("1.0", tk.END)

            self.execution_label.config(text=f"Executing: {script_path}")
            if platform.system() == "Windows":
                process = subprocess.Popen([script_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, text=True)
            else:  # Assume Linux
                process = subprocess.Popen(["bash", script_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

            progress = 0
            while True:
                output = process.stdout.readline()
                if output == "" and process.poll() is not None:
                    break
                if output:
                    self.output_text.insert(tk.END, output, "green_text")
                    self.output_text.see(tk.END)
                    progress = (progress + 10) % 100  # Simulate progress
                    self.progress_bar["value"] = progress
                    self.output_text.update_idletasks()

            stderr_output = process.stderr.read()
            if stderr_output:
                self.output_text.insert(tk.END, stderr_output, "green_text")
                self.output_text.see(tk.END)

            process.stdout.close()
            process.stderr.close()

            self.progress_bar["value"] = 0  # Reset progress bar
            self.execution_label.config(text="Execution completed")
            messagebox.showinfo("Execution Complete", f"{os.path.basename(script_path)} executed successfully.")
        except Exception as e:
            self.execution_label.config(text="Execution failed")
            messagebox.showerror("Error", f"Error executing script: {str(e)}")

    def update_buttons(self):
        """Update the state of navigation buttons."""
        self.back_button.config(state=tk.NORMAL if self.back_stack else tk.DISABLED)
        self.forward_button.config(state=tk.NORMAL if self.forward_stack else tk.DISABLED)


# Run the application
if __name__ == "__main__":
    root = tk.Tk()
    app = DirectoryNavigator(root)
    root.mainloop()

