import { backend } from 'declarations/backend';

const form = document.getElementById('add-item-form');
const input = document.getElementById('new-item');
const list = document.getElementById('shopping-list');

async function loadItems() {
  const items = await backend.getItems();
  list.innerHTML = '';
  items.forEach(item => {
    const li = document.createElement('li');
    li.innerHTML = `
      <span class="${item.completed ? 'completed' : ''}">${item.text}</span>
      <button class="delete-btn"><i class="fas fa-trash"></i></button>
    `;
    li.dataset.id = item.id;
    li.addEventListener('click', toggleComplete);
    li.querySelector('.delete-btn').addEventListener('click', deleteItem);
    list.appendChild(li);
  });
}

async function addItem(e) {
  e.preventDefault();
  const text = input.value.trim();
  if (text) {
    await backend.addItem(text);
    input.value = '';
    loadItems();
  }
}

async function toggleComplete(e) {
  if (e.target.tagName === 'SPAN') {
    const id = Number(e.target.parentElement.dataset.id);
    await backend.toggleComplete(id);
    loadItems();
  }
}

async function deleteItem(e) {
  e.stopPropagation();
  const id = Number(e.target.closest('li').dataset.id);
  await backend.deleteItem(id);
  loadItems();
}

form.addEventListener('submit', addItem);

// Initial load
loadItems();
