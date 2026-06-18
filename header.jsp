<%@ taglib prefix="c" uri="http://java.sun.com/jsp/libs/standard/core" %>

<style>
  /* ── Design System Variables (SBI Corporate Indigo-Blue Theme) ── */
  :root {
    --sbi-primary:      #1E3A8A; /* Official deep SBI Indigo Blue */
    --sbi-accent:       #00BFFF; /* SBI accent light blue */
    --sbi-dark:         #111827; /* Rich text */
    --sbi-bg-subtle:    #F3F4F6;
    --sbi-border:       #E5E7EB;
    --font-stack:       system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  }

  .sbi-header-container {
    font-family: var(--font-stack);
    background-color: #ffffff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.06);
    width: 100%;
    position: relative;
    z-index: 9999;
  }

  /* ── Identity Top Row Bar ──────────────────────── */
  .sbi-top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 24px;
    border-bottom: 1px solid var(--sbi-border);
  }

  .sbi-brand-zone {
    display: flex;
    align-items: center;
    gap: 16px;
  }

  .sbi-brand-zone img {
    height: 48px;
    object-fit: contain;
  }

  .sbi-user-meta {
    display: flex;
    align-items: center;
    gap: 24px;
  }

  .user-badge {
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .user-badge img {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: var(--sbi-bg-subtle);
  }

  .user-info p { 
    margin: 0; 
    font-size: 13.5px; 
    font-weight: 600; 
    color: var(--sbi-dark); 
  }
  .user-info span { 
    font-size: 11px; 
    color: #6B7280; 
    text-transform: uppercase; 
    letter-spacing: 0.5px;
  }

  .meta-data-item {
    font-size: 12px;
    color: #4B5563;
  }
  .meta-data-item span {
    display: block;
    color: #9CA3AF;
    font-size: 11px;
    text-transform: uppercase;
  }
  .meta-data-item strong { 
    color: var(--sbi-dark); 
    font-weight: 600;
  }

  .btn-logout {
    display: flex;
    align-items: center;
    gap: 8px;
    background-color: #EF4444;
    color: #ffffff;
    text-decoration: none;
    padding: 8px 16px;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 500;
    transition: background-color 0.2s;
  }
  .btn-logout:hover { background-color: #DC2626; }
  .btn-logout img { width: 14px; height: 14px; filter: brightness(0) invert(1); }

  /* ── Flexbox Dynamic Navigation Menu ────────────── */
  .sbi-nav-bar {
    background-color: var(--sbi-primary);
    padding: 0 24px;
  }

  .sbi-menu-root {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    gap: 4px;
  }

  .menu-item { position: relative; }

  .menu-trigger {
    display: block;
    color: rgba(255, 255, 255, 0.9);
    text-decoration: none;
    padding: 14px 20px;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.2s;
    cursor: pointer;
    border: none;
    background: transparent;
  }
  .menu-item:hover > .menu-trigger,
  .menu-trigger.clicked {
    background-color: rgba(255, 255, 255, 0.15);
    color: #ffffff;
  }

  /* Dropdown Engine Panel Layout */
  .dropdown-panel {
    position: absolute;
    top: 100%;
    left: 0;
    background-color: #ffffff;
    border: 1px solid var(--sbi-border);
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
    border-radius: 0 0 6px 6px;
    min-width: 250px;
    z-index: 10000;
    opacity: 0;
    visibility: hidden;
    transform: translateY(8px);
    transition: opacity 0.15s ease, transform 0.15s ease, visibility 0.15s;
    list-style: none;
    padding: 6px 0;
    margin: 0;
  }

  /* Active states via Hover and Dynamic Fallback Engine toggles */
  .menu-item:hover .dropdown-panel,
  .dropdown-panel.opensub {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
  }

  .dropdown-panel li { position: relative; }
  
  .dropdown-panel a {
    display: block;
    padding: 10px 16px;
    color: var(--sbi-dark);
    text-decoration: none;
    font-size: 13.5px;
    transition: background-color 0.15s, color 0.15s;
  }
  .dropdown-panel a:hover {
    background-color: var(--sbi-bg-subtle);
    color: var(--sbi-primary);
  }

  /* Multi-level Dropdown Layout (List1 Submenu Mapping) */
  .dropdown-panel .dropdown-panel {
    left: 100%;
    top: 0;
    border-radius: 6px;
  }
  
  .has-submenu > a::after {
    content: '›';
    float: right;
    font-weight: bold;
    color: #9CA3AF;
    margin-left: 8px;
  }
</style>

<header class="sbi-header-container">
  
  <div class="sbi-top-bar">
    <div class="sbi-brand-zone">
      <img src="<c:url value='/static/img/Sbi merger.png'/>" alt="SBI Corporate" />
      <img src="<c:url value='/static/img/CKYC_new_logo.png'/>" alt="CKYC System" />
    </div>

    <div class="sbi-user-meta">
      <div class="user-badge">
        <img src="<c:url value='/static/img/user_icon.png'/>" alt="Profile" />
        <div class="user-info">
          <p><c:out value="${sessionScope.USERNAME}" default="SBI User"/></p>
          <span><c:out value="${sessionScope.ROLE}" default="Officer"/></span>
        </div>
      </div>

      <div class="meta-data-item">
        <span>LCPC Code</span>
        <strong><c:out value="${sessionScope.lcpc_code}" default="-"/></strong>
      </div>

      <div class="meta-data-item">
        <span>Last Successful Login</span>
        <strong><c:out value="${sessionScope.LASTSUCCESSFULLOGIN}" default="-"/></strong>
      </div>

      <a href="<c:url value='/CKYC_new/logout.html'/>" class="btn-logout" onclick="return ConfirmLogOut();">
        <img src="<c:url value='/static/img/logout_icon.png'/>" alt="" />
        <span>Logout</span>
      </a>
    </div>
  </div>

  <nav class="sbi-nav-bar">
    <ul class="sbi-menu-root">
      
      <li class="menu-item">
        <a class="menu-trigger" id="menuClicker3">CKYC Menu</a>
        <ul class="dropdown-panel" id="toggledUL3">
          <c:if test="${not empty list}">
            <c:forEach items="${list}" var="activity">
              
              <c:choose>
                {/* Check if dynamic table configurations specify child submenus */}
                <c:when test="${not empty list1}">
                  <li class="has-submenu">
                    <a href="#" id="menuUrl${activity.menuSeqNo}"><c:out value="${activity.labelName}"/></a>
                    <ul class="dropdown-panel">
                      <c:forEach items="${list1}" var="activity1">
                        <li>
                          <a href="<c:url value='${activity1.url}'/>" target="${activity1.url eq '/CKYC_new/VCIP/redirectToVKYC.html' ? '_blank' : ''}">
                            <c:out value="${activity1.labelName}"/>
                          </a>
                        </li>
                      </c:forEach>
                    </ul>
                  </li>
                </c:when>
                
                <c:otherwise>
                  <li>
                    <a href="<c:url value='${activity.url}'/>" id="menuUrl${activity.menuSeqNo}" target="${activity.url eq '/CKYC_new/VCIP/redirectToVKYC.html' ? '_blank' : ''}">
                      <c:out value="${activity.labelName}"/>
                    </a>
                  </li>
                </c:otherwise>
              </c:choose>

            </c:forEach>
          </c:if>
        </ul>
      </li>

      <li class="menu-item">
        <a class="menu-trigger" id="menuClicker2">Workflow Menu</a>
        <ul class="dropdown-panel" id="toggledUL2">
          <c:if test="${not empty list3}">
            <c:forEach items="${list3}" var="activity2">
              <li>
                <a href="<c:url value='${activity2.url}'/>"><c:out value="${activity2.labelName}"/></a>
              </li>
            </c:forEach>
          </c:if>
        </ul>
      </li>

      <li class="menu-item">
        <a class="menu-trigger" id="menuClicker4">Non Individual Menu</a>
        <ul class="dropdown-panel" id="toggledUL4">
          <c:if test="${not empty list5}">
            <c:forEach items="${list5}" var="activity2">
              <li>
                <a href="<c:url value='${activity2.url}'/>"><c:out value="${activity2.labelName}"/></a>
              </li>
            </c:forEach>
          </c:if>
        </ul>
      </li>

      <li class="menu-item">
        <a class="menu-trigger" id="menuClicker1">KYC Update</a>
        <ul class="dropdown-panel" id="toggledUL1">
          <c:if test="${not empty list7}">
            <c:forEach items="${list7}" var="activity2">
              <li>
                <a href="<c:url value='${activity2.url}'/>"><c:out value="${activity2.labelName}"/></a>
              </li>
            </c:forEach>
          </c:if>
        </ul>
      </li>

    </ul>
  </nav>
</header>

<input type="hidden" id="userCapability" value="<c:out value='${sessionScope.userCapability}'/>" />

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const triggers = document.querySelectorAll('.menu-trigger');
    
    triggers.forEach(trigger => {
      trigger.addEventListener('click', function(e) {
        e.stopPropagation();
        const targetId = this.id;
        
        const mapping = {
          'menuClicker3': 'toggledUL3',
          'menuClicker2': 'toggledUL2',
          'menuClicker4': 'toggledUL4',
          'menuClicker1': 'toggledUL1'
        };

        Object.keys(mapping).forEach(key => {
          const panel = document.getElementById(mapping[key]);
          const currentTrigger = document.getElementById(key);
          
          if(key === targetId) {
            panel.classList.toggle('opensub');
            currentTrigger.classList.toggle('clicked');
          } else {
            if(panel) panel.classList.remove('opensub');
            if(currentTrigger) currentTrigger.classList.remove('clicked');
          }
        });
      });
    });

    // Close open menus automatically when clicking anywhere else on screen
    document.addEventListener('click', function() {
      document.querySelectorAll('.dropdown-panel').forEach(panel => panel.classList.remove('opensub'));
      triggers.forEach(t => t.classList.remove('clicked'));
    });
  });

  function ConfirmLogOut() {
    return confirm("Are you sure you want to secure log out of this SBI portal session?");
  }
</script>
