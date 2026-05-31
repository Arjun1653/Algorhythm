/* components.jsx — shared UI primitives */

// ── Device shell ───────────────────────────────────────────
function StatusBar() {
  return (
    <div className="statusbar">
      <span className="clock">9:41</span>
      <div className="punch" />
      <div className="sysicons">
        <IconWifi size={15} />
        <IconCell size={15} />
        <IconBattery size={15} />
      </div>
    </div>
  );
}

function PhoneShell({ children, nav }) {
  return (
    <div className="phone">
      <StatusBar />
      <div className="viewport" id="viewport">{children}</div>
      {nav}
      <div className="gesturebar"><div className="pill" /></div>
    </div>
  );
}

// ── Bottom navigation ──────────────────────────────────────
const NAV_ITEMS = [
  { id: 'home',      label: 'Home',      Icon: IconHome },
  { id: 'roadmap',   label: 'Roadmap',   Icon: IconRoadmap },
  { id: 'log',       label: 'Log',       Icon: IconLog },
  { id: 'analytics', label: 'Stats',     Icon: IconChart },
];

function BottomNav({ active, onNav, onAdd, showFab }) {
  return (
    <React.Fragment>
      {showFab && (
        <button className="fab tap" onClick={onAdd} aria-label="Add problem">
          <IconPlus size={26} />
        </button>
      )}
      <nav className={'bottomnav' + (showFab ? ' with-fab' : '')}>
        {NAV_ITEMS.map(({ id, label, Icon }) => {
          const on = active === id;
          return (
            <button key={id} className={'navitem tap' + (on ? ' on' : '')} onClick={() => onNav(id)}>
              <span className="navpip"><Icon size={23} sw={on ? 2 : 1.7} /></span>
              <span className="navlabel">{label}</span>
            </button>
          );
        })}
      </nav>
    </React.Fragment>
  );
}

// ── Progress bar ───────────────────────────────────────────
function Progress({ pct, color = 'var(--accent)', h = 6, track = 'var(--surface-3)' }) {
  return (
    <div style={{ height: h, borderRadius: h, background: track, overflow: 'hidden', width: '100%' }}>
      <div style={{
        height: '100%', width: Math.max(pct, pct > 0 ? 4 : 0) + '%',
        background: color, borderRadius: h,
        transition: 'width .6s cubic-bezier(.22,.61,.36,1)',
      }} />
    </div>
  );
}

// ── Difficulty chip ────────────────────────────────────────
function Difficulty({ level }) {
  return <span className={'chip ' + level}>{level}</span>;
}

// ── Confidence selector (stars or dots) ────────────────────
function Confidence({ value = 0, onChange, mode = 'stars', size = 26, readOnly = false, gap = 8 }) {
  const items = [1, 2, 3, 4, 5];
  return (
    <div style={{ display: 'flex', gap }}>
      {items.map((n) => {
        const filled = n <= value;
        const common = {
          onClick: readOnly ? undefined : () => onChange && onChange(n),
          className: readOnly ? '' : 'tap',
          style: {
            cursor: readOnly ? 'default' : 'pointer',
            color: filled ? 'var(--accent)' : 'var(--text-3)',
            display: 'flex', padding: readOnly ? 0 : 2,
            transition: 'color .18s ease, transform .12s ease',
          },
        };
        if (mode === 'dots') {
          return (
            <button key={n} {...common} aria-label={'level ' + n}>
              <span style={{
                width: size - 8, height: size - 8, borderRadius: '50%',
                background: filled ? 'var(--accent)' : 'transparent',
                border: '2px solid ' + (filled ? 'var(--accent)' : 'var(--border-strong)'),
                transition: 'all .18s ease',
              }} />
            </button>
          );
        }
        return (
          <button key={n} {...common} aria-label={'level ' + n}>
            <IconStar size={size} filled={filled} sw={1.8} />
          </button>
        );
      })}
    </div>
  );
}

// ── Heatmap (GitHub-style, 4 levels) ───────────────────────
function Heatmap({ cells, cell = 12, gap = 3 }) {
  const weeks = [];
  for (let w = 0; w < Math.ceil(cells.length / 7); w++) {
    weeks.push(cells.slice(w * 7, w * 7 + 7));
  }
  return (
    <div style={{ display: 'flex', gap, overflowX: 'auto', paddingBottom: 4 }} className="heatscroll">
      {weeks.map((week, wi) => (
        <div key={wi} style={{ display: 'flex', flexDirection: 'column', gap }}>
          {week.map((v, di) => (
            <div key={di} title={`Level ${v}`} style={{
              width: cell, height: cell, borderRadius: 3,
              background: `var(--heat-${v})`,
              flexShrink: 0,
            }} />
          ))}
        </div>
      ))}
    </div>
  );
}

// ── Section heading ────────────────────────────────────────
function SectionLabel({ children, action }) {
  return (
    <div className="row" style={{ justifyContent: 'space-between', margin: '0 2px 12px' }}>
      <span className="eyebrow">{children}</span>
      {action}
    </div>
  );
}

Object.assign(window, {
  PhoneShell, StatusBar, BottomNav, NAV_ITEMS, Progress, Difficulty, Confidence, Heatmap, SectionLabel,
});
