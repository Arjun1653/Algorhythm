/* screen_log.jsx — Problem Log */

const STATUS_META = {
  solved:    { label: 'Solved',    color: 'var(--emerald)' },
  review:    { label: 'Review',    color: 'var(--amber)' },
  attempted: { label: 'Retry',     color: 'var(--text-3)' },
};

function LogItem({ p }) {
  const s = STATUS_META[p.status];
  return (
    <div className="card tap" style={{ padding: '14px 16px', marginBottom: 10, cursor: 'pointer' }}>
      <div className="row" style={{ gap: 12 }}>
        <div style={{
          width: 8, height: 8, borderRadius: 8, flexShrink: 0,
          background: s.color, marginTop: 6, alignSelf: 'flex-start',
          boxShadow: '0 0 0 4px color-mix(in oklch, ' + s.color + ' 16%, transparent)',
        }} />
        <div style={{ flex: 1, minWidth: 0 }}>
          <div className="row" style={{ justifyContent: 'space-between', gap: 8 }}>
            <span className="disp" style={{ fontSize: 15.5, fontWeight: 600, letterSpacing: '-.2px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{p.name}</span>
            <span className="mono" style={{ fontSize: 11, color: s.color, fontWeight: 600, flexShrink: 0 }}>{s.label}</span>
          </div>
          <div className="row" style={{ gap: 8, marginTop: 10, flexWrap: 'wrap' }}>
            <Difficulty level={p.difficulty} />
            <span className="mono" style={{ fontSize: 11, color: 'var(--text-2)', padding: '4px 8px', background: 'var(--surface-3)', borderRadius: 8 }}>{p.platform}</span>
            <span className="mono" style={{ fontSize: 11, color: 'var(--text-3)', alignSelf: 'center' }}>{p.pattern}</span>
            <span className="mono" style={{ fontSize: 11, color: 'var(--text-3)', marginLeft: 'auto', alignSelf: 'center' }}>{p.when}</span>
          </div>
        </div>
      </div>
    </div>
  );
}

function LogScreen() {
  const [q, setQ] = React.useState('');
  const [filter, setFilter] = React.useState('all');
  const filters = [
    { id: 'all', label: 'All' },
    { id: 'review', label: 'Review' },
    { id: 'solved', label: 'Solved' },
    { id: 'attempted', label: 'Retry' },
  ];
  const list = PROBLEMS.filter(p => {
    const matchQ = !q || (p.name + p.platform + p.pattern + p.topic).toLowerCase().includes(q.toLowerCase());
    const matchF = filter === 'all' || p.status === filter;
    return matchQ && matchF;
  });

  return (
    <div className="screen animate-in" style={{ paddingTop: 14 }}>
      <div style={{ padding: '0 2px 4px' }}>
        <div className="eyebrow">{PROBLEMS.length} logged</div>
        <div className="disp" style={{ fontSize: 28, fontWeight: 700, letterSpacing: '-.8px', marginTop: 4 }}>Problem Log</div>
      </div>

      {/* search */}
      <div className="row" style={{
        gap: 10, marginTop: 16, padding: '0 14px', height: 48,
        background: 'var(--surface-2)', border: '1px solid var(--border)', borderRadius: 16,
      }}>
        <span style={{ color: 'var(--text-3)', display: 'flex' }}><IconSearch size={19} /></span>
        <input
          value={q}
          onChange={(e) => setQ(e.target.value)}
          placeholder="Search problems, patterns…"
          style={{
            flex: 1, border: 'none', outline: 'none', background: 'transparent',
            color: 'var(--text-1)', fontFamily: 'var(--font-body)', fontSize: 14.5,
          }}
        />
        {q && <button className="tap" onClick={() => setQ('')} style={{ color: 'var(--text-3)', display: 'flex' }}><IconClose size={18} /></button>}
      </div>

      {/* filter chips */}
      <div style={{ display: 'flex', gap: 8, marginTop: 14, overflowX: 'auto' }} className="heatscroll">
        {filters.map(f => (
          <button key={f.id} className="tap" onClick={() => setFilter(f.id)} style={{
            flexShrink: 0, padding: '7px 15px', borderRadius: 12,
            fontFamily: 'var(--font-display)', fontWeight: 600, fontSize: 13,
            background: filter === f.id ? 'var(--accent)' : 'var(--surface-2)',
            color: filter === f.id ? 'var(--on-accent)' : 'var(--text-2)',
            border: '1px solid ' + (filter === f.id ? 'var(--accent)' : 'var(--border)'),
          }}>{f.label}</button>
        ))}
      </div>

      <div style={{ marginTop: 16 }}>
        {list.length ? list.map(p => <LogItem key={p.id} p={p} />) : (
          <div className="mono" style={{ textAlign: 'center', color: 'var(--text-3)', fontSize: 13, padding: '48px 0' }}>
            No problems match “{q}”
          </div>
        )}
      </div>
    </div>
  );
}

Object.assign(window, { LogScreen });
