import { useEffect, useState } from "react";
import "./App.css";

const API_URL = "http://localhost:8000/todos/";

function App() {
  const [todos, setTodos] = useState([]);
  const [description, setDescription] = useState("");

  const fetchTodos = async () => {
    try {
      const response = await fetch(API_URL);

      if (!response.ok) {
        throw new Error("Failed to fetch todos");
      }

      const data = await response.json();
      setTodos(data);
    } catch (error) {
      console.error("Failed to fetch todos:", error);
    }
  };

  useEffect(() => {
    fetchTodos();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();

    const trimmedDescription = description.trim();

    if (!trimmedDescription) return;

    try {
      const response = await fetch(API_URL, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          description: trimmedDescription,
        }),
      });

      if (!response.ok) {
        throw new Error("Failed to create todo");
      }

      setDescription("");
      await fetchTodos();
    } catch (error) {
      console.error("Failed to create todo:", error);
    }
  };

  return (
    <div className="App">
      <div>
        <h1>List of TODOs</h1>

        <ul>
          {todos.map((todo) => (
            <li key={todo.id}>{todo.description}</li>
          ))}
        </ul>
      </div>

      <div>
        <h1>Create a ToDo</h1>

        <form onSubmit={handleSubmit}>
          <div>
            <label htmlFor="todo">ToDo: </label>

            <input
              id="todo"
              type="text"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
            />
          </div>

          <div style={{ marginTop: "5px" }}>
            <button type="submit">Add ToDo!</button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default App;

