<!-- 
  NOTE: If your Header.jsp already includes jQuery or DataTables, 
  you can remove these <script> and <link> tags here. 
-->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />

<style>
  /* Base styles (scoped to this view's elements) */
  :root {
    --bg:          #f0f2f5;
    --surface:     #ffffff;
    --border:      #e4e7ec;
    --border-2:    #d0d5dd;
    --text:        #101828;
    --text-2:      #475467;
    --text-3:      #98a2b3;
    --accent:      #2563eb;
    --accent-bg:   #eff4ff;
    --gray-bg:     #f9fafb;
    --gray-text:   #344054;
    --radius:      8px;

    --font:        system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    --mono:        ui-monospace, Consolas, "Liberation Mono", Menlo, monospace;
  }
  
  .approvals-container {
    font-family: var(--font);
    font-size: 14px;
    background: var(--bg);
    color: var(--text);
    min-height: 100vh;
    padding: 32px 28px 48px;
    -webkit-font-smoothing: antialiased;
  }

  /* ── Page Header ───────────────────────────────── */
  .page-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    margin-bottom: 20px;
    gap: 16px;
  }
  .page-title   { font-size: 20px; font-weight: 600; color: var(--text); letter-spacing: -0.3px; }
  .page-sub     { font-size: 13px; color: var(--text-2); margin-top: 3px; }

  /* ── Card ──────────────────────────────────────── */
  .card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(16,24,40,0.06), 0 1px 2px rgba(16,24,40,0.04);
  }

  /* ── Toolbar ───────────────────────────────────── */
  .toolbar {
    padding: 14px 16px;
    display: flex;
    align-items: center;
    gap: 10px;
    border-bottom: 1px solid var(--border);
    flex-wrap: wrap;
  }
  .search-box {
    position: relative;
    flex: 1;
    min-width: 180px;
    max-width: 280px;
  }
  .search-box svg {
    position: absolute;
    left: 10px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--text-3);
    pointer-events: none;
  }
  .search-box input {
    width: 100%;
    height: 36px;
    padding: 0 12px 0 34px;
    border: 1px solid var(--border);
    border-radius: var(--radius);
    font-family: var(--font);
    font-size: 13.5px;
    color: var(--text);
    background: var(--bg);
    outline: none;
    transition: border-color 0.15s, box-shadow 0.15s;
  }
  .search-box input::placeholder { color: var(--text-3); }
  .search-box input:focus {
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
    background: #fff;
  }
  .btn-ghost {
    height: 36px;
    padding: 0 14px;
    border: 1px solid var(--border);
    border-radius: var(--radius);
    background: var(--surface);
    font-family: var(--font);
    font-size: 13px;
    color: var(--text-2);
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    white-space: nowrap;
    transition: background 0.15s, border-color 0.15s;
  }
  .btn-ghost:hover { background: var(--bg); border-color: var(--border-2); color: var(--text); }
  .row-count {
    margin-left: auto;
    font-size: 12.5px;
    color: var(--text-3);
    white-space: nowrap;
  }

  /* ── Override ALL DataTables default CSS ───────── */
  /* Remove DataTables default dark bottom border */
table.dataTable.no-footer,
table.dataTable {
  border-bottom: none !important;
}
  
  
  .dataTables_wrapper { padding: 0 !important; }
  .dataTables_wrapper .dataTables_length,
  .dataTables_wrapper .dataTables_filter,
  .dataTables_wrapper .dataTables_info { display: none !important; }
  table.dataTable {
    width: 100% !important;
    border-collapse: collapse !important;
    margin: 0 !important;
    font-family: var(--font) !important;
    font-size: 13.5px !important;
    border-spacing: 0 !important;
  }

  table.dataTable thead tr { background: var(--gray-bg) !important; }
  table.dataTable thead th {
    padding: 10px 14px !important;
    border-bottom: 1px solid var(--border) !important;
    border-top: none !important;
    border-left: none !important;
    border-right: none !important;
    font-size: 11.5px !important;
    font-weight: 600 !important;
    text-transform: uppercase !important;
    letter-spacing: 0.5px !important;
    color: var(--text-3) !important;
    white-space: nowrap;
    background: var(--gray-bg) !important;
  }

  table.dataTable thead th:not(:last-child),
  table.dataTable tbody td:not(:last-child) {
    border-right: 1px solid var(--border) !important;
  }

  /* Sorting icons */
  table.dataTable thead .sorting::after,
  table.dataTable thead .sorting_asc::after,
  table.dataTable thead .sorting_desc::after,
  table.dataTable thead .sorting::before,
  table.dataTable thead .sorting_asc::before,
  table.dataTable thead .sorting_desc::before { opacity: 0; }

  table.dataTable thead th.sorting,
  table.dataTable thead th.sorting_asc,
  table.dataTable thead th.sorting_desc {
    cursor: pointer;
    padding-right: 26px !important;
    position: relative;
  }
  table.dataTable thead th.sorting::after,
  table.dataTable thead th.sorting_asc::after,
  table.dataTable thead th.sorting_desc::after {
    content: '' !important;
    opacity: 1 !important;
    position: absolute !important;
    right: 10px !important;
    top: 50% !important;
    transform: translateY(-50%) !important;
    width: 0; height: 0;
    font-size: 0 !important;
  }
  table.dataTable thead th.sorting::after {
    border-left: 4px solid transparent; border-right: 4px solid transparent; border-bottom: 4px solid var(--text-3); margin-top: -5px; opacity: 0.35 !important;
  }
  table.dataTable thead th.sorting_asc::after {
    border-left: 4px solid transparent; border-right: 4px solid transparent; border-bottom: 5px solid var(--accent); margin-top: -4px; opacity: 1 !important;
  }
  table.dataTable thead th.sorting_desc::after {
    border-left: 4px solid transparent; border-right: 4px solid transparent; border-top: 5px solid var(--accent); margin-top: 1px; opacity: 1 !important;
  }

  /* Body cells */
  table.dataTable tbody tr { border-bottom: 1px solid var(--border) !important; transition: background 0.1s; }
  table.dataTable tbody tr:last-child { border-bottom: none !important; }
  table.dataTable tbody tr:hover td { background: #f5f8ff !important; }

  table.dataTable tbody td {
    padding: 11px 14px !important;
    border-top: none !important; border-left: none !important; border-bottom: none !important;
    vertical-align: middle;
    background: #fff;
    color: var(--text) !important;
  }
  table.dataTable.stripe tbody tr.odd td, table.dataTable.display tbody tr.odd td { background: #fff !important; }
  table.dataTable.stripe tbody tr.odd:hover td, table.dataTable.display tbody tr.odd:hover td { background: #f5f8ff !important; }
  table.dataTable tbody td.dataTables_empty {
    text-align: center !important; color: var(--text-3) !important; padding: 48px !important; font-size: 14px !important; border-right: none !important;
  }

  /* ── Cell Styles ───────────────────────────────── */
  .cell-mono {
    font-family: var(--mono);
    font-size: 12.5px;
    color: var(--text);
    white-space: nowrap;
  }
  .cell-text {
    font-size: 13px;
    color: var(--text-2);
  }

  .actions { display: flex; align-items: center; gap: 6px; }
  .act {
    height: 28px;
    padding: 0 10px;
    border-radius: 6px;
    border: 1px solid var(--border);
    background: var(--surface);
    font-family: var(--font);
    font-size: 12px;
    font-weight: 500;
    cursor: pointer;
    color: var(--text-2);
    transition: all 0.15s;
    white-space: nowrap;
  }
  .act:hover { background: var(--bg); border-color: var(--border-2); color: var(--text); }
  .act.retry { color: var(--accent); border-color: #bfdbfe; background: #eff8ff; }
  .act.retry:hover { background: #dbeafe; }
  .act.send-back { color: #b54708; border-color: #fde047; background: #fffaeb; }
  .act.send-back:hover { background: #fef08a; }

  /* ── Loading Overlay ───────────────────────────── */
  .table-wrapper { position: relative; }
  .loading-overlay {
    position: absolute; inset: 0; background: rgba(255,255,255,0.7);
    display: flex; align-items: center; justify-content: center;
    font-weight: 500; color: var(--accent); z-index: 10;
    display: none;
  }
  .loading-overlay.active { display: flex; }

  /* ── Footer / Pagination ───────────────────────── */
  .table-footer {
    padding: 12px 16px; display: flex; align-items: center; justify-content: space-between;
    border-top: 1px solid var(--border); background: var(--gray-bg); gap: 12px; flex-wrap: wrap;
  }
  .footer-left { font-size: 13px; color: var(--text-2); }
  .footer-left strong { color: var(--text); }
  .pg { display: flex; align-items: center; gap: 3px; }
  .pg-btn {
    min-width: 32px; height: 32px; padding: 0 6px; border: 1px solid var(--border);
    border-radius: 6px; background: var(--surface); font-family: var(--font);
    font-size: 13px; color: var(--text-2); cursor: pointer;
    display: flex; align-items: center; justify-content: center; transition: all 0.15s;
  }
  .pg-btn:hover:not(:disabled):not(.active) { background: var(--bg); border-color: var(--border-2); color: var(--text); }
  .pg-btn.active { background: var(--accent); border-color: var(--accent); color: #fff; font-weight: 600; }
  .pg-btn:disabled { opacity: 0.4; cursor: default; }

  /* ── Toast ─────────────────────────────────────── */
  #toasts { position: fixed; bottom: 24px; right: 24px; z-index: 9999; display: flex; flex-direction: column; gap: 8px; }
  .toast {
    padding: 12px 18px; border-radius: 10px; font-size: 13.5px; font-weight: 500;
    color: #fff; display: flex; align-items: center; gap: 8px;
    box-shadow: 0 4px 16px rgba(0,0,0,0.14); animation: tin 0.22s ease;
  }
  @keyframes tin { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
  .toast.s { background: #16a34a; }
  .toast.e { background: #dc2626; }
  .toast.w { background: #d97706; }
</style>

<!-- Main Wrapper for the View -->
<div class="approvals-container">
  <div class="page-header">
    <div>
      <div class="page-title">Approver Worklist</div>
      <div class="page-sub">Records awaiting your review and action</div>
    </div>
  </div>

  <div class="card">
    <!-- Toolbar -->
    <div class="toolbar">
      <div class="search-box">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
        <input type="search" id="search" placeholder="Search CIF, Account…" />
      </div>

      <!-- Filter Buttons -->
      <button class="btn-ghost" onclick="setFilter('all')" id="f-all" style="border-color:#2563eb;color:#2563eb;background:#eff4ff">All</button>
      <button class="btn-ghost" onclick="setFilter('priority')" id="f-priority">Priority</button>

      <span class="row-count" id="rc">0 records</span>
    </div>

    <!-- Table Area -->
    <div class="table-wrapper">
      <div class="loading-overlay" id="loader">Fetching data...</div>
      <table id="tbl" style="width:100%">
        <thead>
          <tr>
            <th>CIF Number</th>
            <th>Account Number</th>
            <th>Branch Code</th>
            <th>Image Rejection Reason</th>
            <th>Image Rejection Remarks</th>
            <th>API Status</th>
            <th>API Remarks</th>
            <th style="text-align:center">Action</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
    </div>

    <!-- Footer -->
    <div class="table-footer">
      <div class="footer-left" id="fi">Showing 0 of 0</div>
      <div class="pg" id="pg"></div>
    </div>
  </div>
</div>

<div id="toasts"></div>

<!-- 
  NOTE: If your Header.jsp already includes jQuery or DataTables, 
  you can remove these <script> tags here. 
-->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script>
  /* ── DataTable Setup ────────────────────────────────────────── */
  let dt, curFilter = 'all';

  $(function () {
    dt = $('#tbl').DataTable({
      data: [], // Initially empty, populated by AJAX
      paging: true,
      pageLength: 10,
      searching: true,
      ordering: true,
      info: false,
      dom: 't',
      columns: [
        { data: 'cif',        render: d => `<span class="cell-mono">${d}</span>` },
        { data: 'acc',        render: d => `<span class="cell-mono">${d}</span>` },
        { data: 'branch',     render: d => `<span class="cell-text"><b>${d}</b></span>` },
        { data: 'rejReason',  render: d => `<span class="cell-text">${d}</span>` },
        { data: 'rejRemarks', render: d => `<span class="cell-text" style="font-style:italic">${d}</span>` },
        
        // Removed badge CSS completely; just plain text now
        { data: 'apiStatus',  render: d => `<span class="cell-text">${d}</span>` },
        
        { data: 'apiRemarks', render: d => `<span class="cell-text">${d}</span>` },
        { data: 'cif',        orderable: false, render: d => `
    <div class="actions">
      <button class="act retry" onclick="act('retry','${d}')">Retry</button>
      <button class="act send-back" onclick="act('sendBack','${d}')">Send Back to Branch</button>
    </div>`
        }
      ],
      drawCallback: redraw
    });

    // Attach search listener
    $('#search').on('input', function(){ dt.search(this.value).draw(); });

    // Initial load
    loadData('all');
  });

  /* ── AJAX Logic (Simulated) ─────────────────────────────────── */
  function loadData(filter) {
    // Show loader
    $('#loader').addClass('active');

    // --- MOCK AJAX DELAY FOR PROTOTYPING ---
    setTimeout(() => {
      let mockData = [
        { cif:'100456789', acc:'000123456789', branch:'BR-001', rejReason:'Signature Mismatch', rejRemarks:'Signature unclear, please verify.', apiStatus:'Failed', apiError: true, apiRemarks:'Connection timeout during validation' },
        { cif:'100456790', acc:'000123456790', branch:'BR-023', rejReason:'Blurry Image', rejRemarks:'Document illegible.', apiStatus:'Pending', apiError: false, apiRemarks:'Awaiting response' },
        { cif:'100456791', acc:'000123456791', branch:'BR-015', rejReason:'Wrong Document', rejRemarks:'Uploaded PAN instead of Aadhaar.', apiStatus:'Failed', apiError: true, apiRemarks:'Validation schema error' },
        { cif:'100456792', acc:'000123456792', branch:'BR-002', rejReason:'Incomplete Forms', rejRemarks:'Missing page 2.', apiStatus:'Failed', apiError: true, apiRemarks:'Internal Server Error 500' }
      ];

      // Filter logic simulation
      if (filter === 'priority') {
        mockData = mockData.filter(d => d.apiError === true);
      }

      dt.clear().rows.add(mockData).draw();
      $('#loader').removeClass('active');
      toast('Data refreshed via AJAX', 's');
    }, 600); // 600ms mock network delay
  }

  /* ── UI Helpers ─────────────────────────────────────────────── */
  function setFilter(f) {
    curFilter = f;

    // Update button UI state
    ['all','priority'].forEach(id => {
      const el = document.getElementById('f-'+id);
      const on = id === f;
      el.style.borderColor = on ? '#2563eb' : '';
      el.style.color       = on ? '#2563eb' : '';
      el.style.background  = on ? '#eff4ff' : '';
    });

    // Trigger AJAX load for the selected filter
    loadData(f);
  }

  function redraw() {
    // FIX: This line prevents the script from crashing during the initial synchronous draw
    if (!dt) return; 

    const i = dt.page.info();
    const total = i.recordsDisplay;
    const from  = total === 0 ? 0 : i.start + 1;
    const to    = Math.min(i.end, total);

    $('#fi').html(`Showing <strong>${from}–${to}</strong> of <strong>${total}</strong>`);
    $('#rc').text(`${total} record${total !== 1 ? 's' : ''}`);
    buildPg(i);
  }

  function buildPg(i) {
    const pages = Math.ceil(i.recordsDisplay / i.length) || 1;
    const cur   = i.page;
    let h = `<button class="pg-btn" onclick="dt.page(${cur-1}).draw('page')" ${cur===0?'disabled':''}>&lsaquo;</button>`;

    for (let p = 0; p < pages; p++) {
      if (pages > 6 && p > 1 && p < pages-1 && Math.abs(p-cur) > 1) {
        if (p === 2) h += `<button class="pg-btn" style="cursor:default" disabled>…</button>`;
        continue;
      }
      h += `<button class="pg-btn${p===cur?' active':''}" onclick="dt.page(${p}).draw('page')">${p+1}</button>`;
    }

    h += `<button class="pg-btn" onclick="dt.page(${cur+1}).draw('page')" ${cur===pages-1||pages===0?'disabled':''}>&rsaquo;</button>`;
    $('#pg').html(h);
  }

  function act(type, cif) {
    const row = $('#tbl tbody').find(`button[onclick*="${cif}"]`).first().closest('tr');
    row.css({ opacity:'0.3', transition:'opacity 0.3s' });

    if (type === 'retry') {
      toast(`Retrying API for CIF ${cif}…`, 's');
    } else {
      toast(`Sent CIF ${cif} back to branch.`, 'w');
    }
  }

  function toast(msg, type) {
    const id = 't'+Date.now();
    const icon = {s:'✔',e:'✖',w:'⚡'}[type];
    $('#toasts').append(`<div class="toast ${type}" id="${id}">${icon} ${msg}</div>`);
    setTimeout(() => $(`#${id}`).remove(), 3000);
  }
</script>
