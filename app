// app.js

let inventario = JSON.parse(localStorage.getItem('inventario')) || [];
let fiados = JSON.parse(localStorage.getItem('fiados')) || [];
let eventos = JSON.parse(localStorage.getItem('eventos')) || [];

function guardarDatos() {
  localStorage.setItem('inventario', JSON.stringify(inventario));
  localStorage.setItem('fiados', JSON.stringify(fiados));
  localStorage.setItem('eventos', JSON.stringify(eventos));
}

function renderizar() {
  // Inventario
  const listaProd = document.getElementById('productsList');
  listaProd.innerHTML = '';
  let totalInv = 0;
  inventario.forEach((item, i) => {
    const total = item.qty * item.price;
    totalInv += total;
    const li = document.createElement('li');
    li.textContent = `${item.name} (${item.category}) – ${item.qty} × $${item.price.toFixed(2)} = $${total.toFixed(2)}`;
    const btn = document.createElement('button');
    btn.textContent = '❌';
    btn.onclick = () => { inventario.splice(i, 1); guardarDatos(); renderizar(); };
    li.appendChild(btn);
    listaProd.appendChild(li);
  });
  document.getElementById('invTotal').textContent = totalInv.toFixed(2);

  // Fiados
  const listaFiados = document.getElementById('fiadosList');
  listaFiados.innerHTML = '';
  let totalFiados = 0;
  fiados.forEach((item, i) => {
    totalFiados += item.balance;
    const li = document.createElement('li');
    li.innerHTML = `<div>${item.name} – ${item.prod} (${item.date})</div><div>Debe: $${item.balance.toFixed(2)}</div>`;
    const abonarBtn = document.createElement('button');
    abonarBtn.textContent = '💵';
    abonarBtn.onclick = () => {
      const monto = parseFloat(prompt('¿Cuánto abona?'));
      if (!isNaN(monto)) {
        item.balance -= monto;
        if (item.balance <= 0) fiados.splice(i, 1);
        guardarDatos();
        renderizar();
      }
    };
    li.appendChild(abonarBtn);
    listaFiados.appendChild(li);
  });
  document.getElementById('fiadoTotalSum').textContent = totalFiados.toFixed(2);

  // Eventos
  const listaEventos = document.getElementById('eventsList');
  listaEventos.innerHTML = '';
  eventos.sort((a,b)=>a.date.localeCompare(b.date));
  eventos.forEach((ev, i) => {
    const li = document.createElement('li');
    li.textContent = `${ev.date}: ${ev.title}`;
    const btn = document.createElement('button');
    btn.textContent = '❌';
    btn.onclick = () => { eventos.splice(i, 1); guardarDatos(); renderizar(); };
    li.appendChild(btn);
    listaEventos.appendChild(li);
  });
}

function addProduct() {
  const name = document.getElementById('prodName').value.trim();
  const qty = parseInt(document.getElementById('prodQty').value);
  const price = parseFloat(document.getElementById('prodPrice').value);
  const category = document.getElementById('prodCategory').value;
  if (!name || isNaN(qty) || isNaN(price)) return alert('Completa los campos del inventario');
  inventario.push({ name, qty, price, category });
  guardarDatos();
  renderizar();
  ['prodName','prodQty','prodPrice'].forEach(id => document.getElementById(id).value = '');
}

function addFiado() {
  const name = document.getElementById('fiadoName').value.trim();
  const prod = document.getElementById('fiadoProd').value.trim();
  const date = document.getElementById('fiadoDate').value;
  const balance = parseFloat(document.getElementById('fiadoTotal').value);
  if (!name || !prod || !date || isNaN(balance)) return alert('Completa los campos de fiado');
  fiados.push({ name, prod, date, balance });
  guardarDatos();
  renderizar();
  ['fiadoName','fiadoProd','fiadoDate','fiadoTotal'].forEach(id => document.getElementById(id).value = '');
}

function addEvent() {
  const date = document.getElementById('eventDate').value;
  const title = document.getElementById('eventTitle').value.trim();
  if (!date || !title) return alert('Completa los datos del evento');
  eventos.push({ date, title });
  guardarDatos();
  renderizar();
  ['eventDate','eventTitle'].forEach(id => document.getElementById(id).value = '');
}

renderizar();
