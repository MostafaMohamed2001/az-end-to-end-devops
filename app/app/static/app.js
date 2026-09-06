const tasksEl = document.getElementById("tasks");
const messageEl = document.getElementById("message");
const form = document.getElementById("task-form");

function showMessage(text) {
    messageEl.innerHTML = text ? `<div class="message">${text}</div>` : "";
}

async function request(path, options = {}) {
    const response = await fetch(path, {
        headers: {"Content-Type": "application/json"},
        ...options,
    });

    if (!response.ok) {
        const body = await response.json().catch(() => ({}));
        throw new Error(body.detail || `Request failed: ${response.status}`);
    }

    if (response.status === 204) return null;
    return response.json();
}

async function loadTasks() {
    try {
        showMessage("");
        const tasks = await request("/api/tasks");

        if (!tasks.length) {
            tasksEl.innerHTML = `<div class="card">No tasks yet.</div>`;
            return;
        }

        tasksEl.innerHTML = tasks.map(task => `
            <article class="task ${task.completed ? "completed" : ""}">
                <h3>${escapeHtml(task.title)}</h3>
                <p>${escapeHtml(task.description || "No description")}</p>
                <div class="task-actions">
                    <button onclick="toggleTask(${task.id}, ${task.completed})">
                        ${task.completed ? "Reopen" : "Complete"}
                    </button>
                    <button class="delete" onclick="deleteTask(${task.id})">
                        Delete
                    </button>
                </div>
            </article>
        `).join("");
    } catch (error) {
        showMessage(error.message);
    }
}

async function toggleTask(id, completed) {
    try {
        await request(`/api/tasks/${id}`, {
            method: "PATCH",
            body: JSON.stringify({completed: !completed}),
        });
        await loadTasks();
    } catch (error) {
        showMessage(error.message);
    }
}

async function deleteTask(id) {
    try {
        await request(`/api/tasks/${id}`, {method: "DELETE"});
        await loadTasks();
    } catch (error) {
        showMessage(error.message);
    }
}

form.addEventListener("submit", async event => {
    event.preventDefault();

    const title = document.getElementById("title").value.trim();
    const description = document.getElementById("description").value.trim();

    try {
        await request("/api/tasks", {
            method: "POST",
            body: JSON.stringify({title, description}),
        });
        form.reset();
        await loadTasks();
    } catch (error) {
        showMessage(error.message);
    }
});

document.getElementById("refresh").addEventListener("click", loadTasks);

function escapeHtml(value) {
    const div = document.createElement("div");
    div.textContent = value;
    return div.innerHTML;
}

loadTasks();
