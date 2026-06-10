<%@ taglib prefix="c" uri="http://java.sun.com/jsp/libs/standard/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />

<style>
  /* Modern Scoped Theme Styles */
  :root {
    --bg:          #f0f2f5;
    --surface:     #ffffff;
    --border:      #e4e7ec;
    --border-2:    #d0d5dd;
    --text:        #101828;
    --text-2:      #475467;
    --text-3:      #98a2b3;
    --accent:      #2174A7; /* Matched to your header background brand color */
    --accent-bg:   #eff4ff;
    --gray-bg:     #f9fafb;
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

  /* ── Card Layout ────────────────────────────────── */
  .card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(16,24,40,0.06), 0 1px 2px rgba(16,24,40,0.04);
  }

  /* ── Dynamic Filter Toolbar ─────────────────────── */
  .toolbar {
    padding: 14px 16px;
    display: flex;
    align-items: center;
    gap: 10px;
    border-bottom: 1px solid var(--border);
    flex-wrap: wrap;
    background: var(--surface);
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
    box-shadow: 0 0 0 3px rgba(33,116,167,0.1);
    background: #fff;
  }
  .row-count {
    margin-left: auto;
    font-size: 12.5px;
    color: var(--text-3);
    white-space: nowrap;
  }

  /* ── DataTables Overrides ───────────────────────── */
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
  table.dataTable thead th {
    padding: 12px 14px !important;
    border-bottom: 1px solid var(--border) !important;
    border-top: none !important; border-left: none !important; border-right: none !important;
    font-size: 11.5px !important;
    font-weight: 600 !important;
    text-transform: uppercase !important;
    letter-spacing: 0.5px !important;
    white-space: nowrap;
  }
  table.dataTable thead th:not(:last-child),
  table.dataTable tbody td:not(:last-child) {
    border-right: 1px solid rgba(255,255,255,0.15) !important;
  }
  table.dataTable tbody td:not(:last-child) {
    border-right: 1px solid var(--border) !important;
  }
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

  /* ── Typography Utilities ───────────────────────── */
  .cell-mono { font-family: var(--mono); font-size: 12.5px; color: var(--text); white-space: nowrap; }
  .cell-text { font-size: 13px; color: var(--text-2); }
  .disabled-link { color: var(--text-3); font-style: italic; font-size: 12.5px; }

  /* ── Action Triggers ────────────────────────────── */
  .actions { display: flex; align-items: center; justify-content: center; gap: 6px; }
  .act {
    height: 28px;
    padding: 0 12px;
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
  .act.retry { color: #15803d; border-color: #bbf7d0; background: #f0fdf4; }
  .act.retry:hover { background: #dcfce7; }
  .act.send-back { color: #b45309; border-color: #fef08a; background: #fefce8; }
  .act.send-back:hover { background: #fef9c3; }

  /* ── Footer Elements ────────────────────────────── */
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
</style>

<div id="overlay" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.2); z-index:9998;"></div>
<div id="loader" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%); z-index:9999; background:#fff; padding:20px; border-radius:8px; box-shadow:0 2px 10px rgba(0,0,0,0.1);">Processing Request...</div>

<div class="approvals-container">
  <div class="page-header">
    <div>
      <div class="page-title">Approver Pending List</div>
      <div class="page-sub">Records awaiting your execution review and actions</div>
    </div>
  </div>

  <c:if test="${message != null && message.length() != 0}">
    <div class="msg msg-error" align="center" id="errormsg" style="background:#fef2f2; border:1px solid #fee2e2; color:#991b1b; padding:12px; border-radius:8px; margin-bottom:16px;">
      <p><strong><c:out value="${message}"/></strong></p>
    </div>
  </c:if>

  <div class="card">
    <div class="toolbar">
      <div class="search-box">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
        <input type="search" id="search" placeholder="Quick Filter Records..." />
      </div>
      <span class="row-count" id="rc">0 records</span>
    </div>

    <form:form role="form" class="form" id="approverUploadPendingList" modelAttribute="approverUploadPendingList" method="POST" action="ApproverPendingList.htm">
      
      <div style="padding: 10px 16px; border-bottom: 1px solid var(--border); background: var(--gray-bg);">
        <table style="width: auto; margin: 0;">
          <tr>
            <td style="padding-right: 10px;">
              <input type="submit" class="act" value="Priority Records" name="priorityCif" id="priorityCif" style="font-weight: 600;" />
            </td>
            <td>
              <input type="submit" class="act" value="All Records" name="allCif" style="font-weight: 600;" />
            </td>
          </tr>
        </table>
      </div>

      <div class="table-responsive" style="padding: 2px 0 0 0;">
        <table class="table table-striped table-bordered table-hover" id="pendingListDatatable">
          <thead>
            <tr style="background-color: #2174A7; color: white;">
              <th>Account Number</th>
              <th>CIF Number</th>
              <th>Branch Code</th>
              <th>Modified Date</th>
              <th>Previous Rejection Reason</th>
              <th>Previous Maker Rejection Remarks</th>
              <th>Image Upload Date</th>
              <th>Re-uploaded/Newly Allocated</th>
              <th>Channel Id</th>
              <th>Retry Count</th>
              <th>Retry Remarks</th>
              <th>Retry Status</th>
              <th>Sent Back Flag</th>
              <th style="text-align:center">Action</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${pendingList}" var="pendingLists" varStatus="vs">
              <tr class="odd gradex">
                <td>
                  <span class="cell-mono">
                    <c:choose>
                      <c:when test="${pendingLists.getAccNum() != null}">
                        <c:out value="${pendingLists.getAccNum()}" />
                      </c:when>
                      <c:otherwise>A/C Number not provided by CBS</c:otherwise>
                    </c:choose>
                  </span>
                </td>
                
                <td>
                  <span class="cell-mono"><c:out value="${pendingLists.getCIF_NUM()}" /></span>
                </td>
                
                <td>
                  <span class="cell-text"><b><c:out value="${pendingLists.getBranch_code()}" /></b></span>
                </td>
                
                <td>
                  <span class="cell-text"><c:out value="${pendingLists.getMODIFIED_DATE()}" /></span>
                </td>
                
                <td>
                  <span class="cell-text">
                    <c:choose>
                      <c:when test="${pendingLists.getPrevRejReason() != null}">
                        <c:out value="${pendingLists.getPrevRejReason()}" />
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                  </span>
                </td>
                
                <td>
                  <span class="cell-text" style="font-style:italic">
                    <c:choose>
                      <c:when test="${pendingLists.getPrevRejRemark() != null}">
                        <c:out value="${pendingLists.getPrevRejRemark()}" />
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                  </span>
                </td>

                <td>
                  <span class="cell-text"><c:out value="${pendingLists.getImageUploadDate()}" /></span>
                </td>

                <td>
                  <span class="cell-text"><c:out value="${pendingLists.getReuploadedFlag()}" /></span>
                </td>

                <td>
                  <span class="cell-text"><c:out value="${pendingLists.getChannelId()}" /></span>
                </td>

                <td>
                  <span class="cell-text"><c:out value="${pendingLists.getRetryCount()}" /></span>
                </td>

                <td>
                  <span class="cell-text"><c:out value="${pendingLists.getRetryRemarks()}" /></span>
                </td>

                <td>
                  <span class="cell-text"><c:out value="${pendingLists.getRetryStatus()}" /></span>
                </td>

                <td>
                  <span class="cell-text"><c:out value="${pendingLists.getSentBackFlag()}" /></span>
                </td>
                
                <td style="text-align:center">
                  <c:choose>
                    <c:when test="${pendingLists.getRetryCount() >= 3}">
                      <span class="disabled-link">Max Retries Reached</span>
                    </c:when>
                    <c:otherwise>
                      <div class="actions">
                        <button type="button" class="act retry" 
                                onclick="postIt('${pendingLists.getCIF_NUM()}', '${pendingLists.getAccNum()}', '${pendingLists.getBranch_code()}', '/Approver/ApproverFormPage.html', '${pendingLists.getChannelId()}', 'retry', '${pendingLists.getRetryRemarks()}')">
                          Retry
                        </button>
                        <button type="button" class="act send-back" 
                                onclick="postIt('${pendingLists.getCIF_NUM()}', '${pendingLists.getAccNum()}', '${pendingLists.getBranch_code()}', '/Approver/ApproverFormPage.html', '${pendingLists.getChannelId()}', 'sendBack', '${pendingLists.getRetryRemarks()}')">
                          Send Back
                        </button>
                      </div>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </form:form>

    <div class="table-footer">
      <div class="footer-left" id="fi">Showing 0 of 0</div>
      <div class="pg" id="pg"></div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script>
  /* ── Security Configuration Context ── */
  var _csrf = {
    parameterName : '${_csrf.parameterName}',
    token : '${_csrf.token}'
  };

  /* ── Native Interface Controller Mechanics ── */
  function showLoader() {
    document.getElementById('overlay').style.display = 'block';
    document.getElementById('loader').style.display = 'block';
  }

  function hideLoader() {
    document.getElementById('overlay').style.display = 'none';
    document.getElementById('loader').style.display = 'none';
  }

  /* Core Architecture AJAX Method unchanged from your design code */
  function postIt(cif_num, acc_num, branch_code, url, channelId, actionType, remark) {
    showLoader();
    
    var payload = new URLSearchParams();
    payload.append('cif_num', cif_num);
    payload.append('acc_num', acc_num);
    payload.append('branch_code', branch_code);
    payload.append('channelId', channelId);
    payload.append('listIdentifier', 'approverPL');
    payload.append('actionType', actionType);
    payload.append('remarks', remark);
    payload.append(_csrf.parameterName, _csrf.token);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.withCredentials = true;
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        hideLoader();
        // Option to refresh the view grid or process explicit state handling here
        if (xhr.status === 200) {
          window.location.reload(); 
        } else {
          alert("Action failed with error code: " + xhr.status);
        }
      }
    };
    xhr.send(payload);
  }

  /* ── DataTables Visual Control Logic Setup ── */
  let dt;

  $(document).ready(function () {
    dt = $('#pendingListDatatable').DataTable({
      paging: true,
      pageLength: 10,
      searching: true,
      ordering: true,
      info: false,
      dom: 't', 
      columnDefs: [
        { orderable: false, targets: 13 } // Action Column sorting safe-disabled
      ],
      drawCallback: redraw
    });

    // Mirror key input string filtering down onto DataTable internals
    $('#search').on('input', function(){ 
      dt.search(this.value).draw(); 
    });

    // Run structural paging layout counters immediately on data initialization
    redraw();
  });

  function redraw() {
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
</script>
