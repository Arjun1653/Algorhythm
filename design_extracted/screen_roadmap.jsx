/* screen_roadmap.jsx — DSA Roadmap (Custom + Striver Mode) */

/* ── Custom Mode ──────────────────────────────────────────── */
function RoadmapNode({ topic, index, last, onTopicPress }) {
  const { name, solved, total, est, state } = topic;
  const pct    = total > 0 ? Math.round((solved / total) * 100) : 0;
  const locked = state === 'locked';
  const done   = state === 'done';
  const active = state === 'active';

  const nodeColor = done ? 'var(--emerald)' : active ? 'var(--accent)' : 'var(--surface-3)';
  const nodeText  = (done || active) ? 'var(--on-accent)' : 'var(--text-3)';

  return (
    <div style={{ display: 'flex', gap: 16, opacity: locked ? 0.52 : 1 }}>
      {/* Rail */}
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', width: 34 }}>
        <div style={{
          width: 34, height: 34, borderRadius: 12, flexShrink: 0,
          background: nodeColor, color: nodeText,
          border: (!done && !active) ? '1px solid var(--border-strong)' : 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 13,
        }}>
          {done   ? <IconCheck size={17} /> :
           locked ? <IconLock  size={15} /> :
           index + 1}
        </div>
        {!last && (
          <div style={{
            width: 2, flex: 1, minHeight: 26,
            background: 'var(--border)', marginTop: 4,
          }} />
        )}
      </div>

      {/* Card */}
      <div
        className={'card' + (!locked ? ' tap' : '')}
        onClick={!locked ? () => onTopicPress(name) : undefined}
        style={{
          flex: 1, padding: 16, marginBottom: 14, cursor: locked ? 'default' : 'pointer',
          borderColor: active ? 'var(--accent-line)' : 'var(--border)',
        }}
      >
        <div className="row" style={{ justifyContent: 'space-between', gap: 10 }}>
          <div className="disp" style={{ fontSize: 16, fontWeight: 600, letterSpacing: '-.2px' }}>{name}</div>
          {active  && <span className="chip" style={{ color: 'var(--accent)', background: 'var(--accent-soft)' }}>Active</span>}
          {done    && <span style={{ color: 'var(--emerald)', display: 'flex' }}><IconCheck size={18} /></span>}
          {!locked && !active && !done && <span style={{ color: 'var(--text-3)', display: 'flex' }}><IconChevron size={16} /></span>}
          {locked  && <span style={{ color: 'var(--text-3)', display: 'flex' }}><IconLock size={16} /></span>}
        </div>

        {!locked ? (
          <React.Fragment>
            <div className="row" style={{ gap: 10, marginTop: 14 }}>
              <Progress pct={pct} color={done ? 'var(--emerald)' : 'var(--accent)'} />
              <span className="mono" style={{
                fontSize: 11.5, fontWeight: 600, color: 'var(--text-2)',
                minWidth: 34, textAlign: 'right',
              }}>{pct}%</span>
            </div>
            <div className="mono" style={{ fontSize: 11, color: 'var(--text-3)', marginTop: 9 }}>
              {solved} / {total} problems
              {state === 'unlocked' && ' · ready to start'}
            </div>
          </React.Fragment>
        ) : (
          <div className="mono" style={{ fontSize: 11, color: 'var(--text-3)', marginTop: 12 }}>
            {est} problems · complete previous topic to unlock
          </div>
        )}
      </div>
    </div>
  );
}

function CustomRoadmap({ onTopicPress }) {
  const doneCount   = ROADMAP.filter(t => t.state === 'done').length;
  const totalSolved = ROADMAP.reduce((a, t) => a + t.solved, 0);
  const totalAll    = ROADMAP.reduce((a, t) => a + t.total, 0);
  const pct         = Math.round((totalSolved / totalAll) * 100);

  return (
    <div>
      {/* Overall progress */}
      <div style={{ marginBottom: 22 }}>
        <div className="row" style={{ gap: 10, marginBottom: 8 }}>
          <Progress pct={pct} h={8} />
          <span className="mono" style={{
            fontSize: 12, fontWeight: 600, color: 'var(--text-2)', whiteSpace: 'nowrap',
          }}>{totalSolved}/{totalAll}</span>
        </div>
        <div className="mono" style={{ fontSize: 11, color: 'var(--text-3)' }}>
          {doneCount} of {ROADMAP.length} topics mastered · tap any unlocked topic to view cheatsheet
        </div>
      </div>

      {ROADMAP.map((t, i) => (
        <RoadmapNode
          key={t.name} topic={t} index={i}
          last={i === ROADMAP.length - 1}
          onTopicPress={onTopicPress}
        />
      ))}
    </div>
  );
}

/* ── Striver Mode ─────────────────────────────────────────── */
function StriverSectionCard({ section, onPress }) {
  const { name, total, solved, active } = section;
  const pct  = total > 0 ? Math.round((solved / total) * 100) : 0;
  const done = pct === 100;

  return (
    <div
      className="card tap"
      onClick={() => onPress && onPress(section)}
      style={{
        padding: '16px 18px', marginBottom: 10, cursor: 'pointer',
        borderColor: active ? 'var(--accent-line)' : done ? 'color-mix(in oklch, var(--emerald) 28%, transparent)' : 'var(--border)',
      }}
    >
      <div className="row" style={{ justifyContent: 'space-between', gap: 10, marginBottom: 12 }}>
        {/* Section number badge */}
        <div style={{
          width: 30, height: 30, borderRadius: 10, flexShrink: 0,
          background: done ? 'var(--emerald)' : active ? 'var(--accent)' : 'var(--surface-3)',
          color: (done || active) ? 'var(--on-accent)' : 'var(--text-3)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 12,
        }}>
          {done ? <IconCheck size={15} /> : section.id}
        </div>

        <div style={{ flex: 1, minWidth: 0 }}>
          <div className="disp" style={{
            fontSize: 14.5, fontWeight: 600, letterSpacing: '-.2px',
            overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
          }}>{name}</div>
        </div>

        {active && (
          <span className="chip" style={{ color: 'var(--accent)', background: 'var(--accent-soft)', flexShrink: 0 }}>
            Active
          </span>
        )}
        {!active && !done && (
          <span style={{ color: 'var(--text-3)', display: 'flex', flexShrink: 0 }}>
            <IconChevron size={16} />
          </span>
        )}
      </div>

      <div className="row" style={{ gap: 10 }}>
        <Progress
          pct={pct}
          color={done ? 'var(--emerald)' : 'var(--accent)'}
          track="var(--surface-3)"
        />
        <span className="mono" style={{
          fontSize: 11, fontWeight: 600, color: 'var(--text-2)',
          minWidth: 48, textAlign: 'right', whiteSpace: 'nowrap',
        }}>{solved} / {total}</span>
      </div>
    </div>
  );
}

function StriverRoadmap({ onSectionPress }) {
  const totalSolved = STRIVER_SECTIONS.reduce((a, s) => a + s.solved, 0);
  const totalAll    = STRIVER_SECTIONS.reduce((a, s) => a + s.total, 0);
  const pct         = Math.round((totalSolved / totalAll) * 100);

  return (
    <div>
      {/* Overall A2Z progress */}
      <div className="card" style={{ padding: '18px 20px', marginBottom: 18 }}>
        <div className="row" style={{ justifyContent: 'space-between', marginBottom: 12 }}>
          <div>
            <div className="disp" style={{ fontSize: 28, fontWeight: 700, letterSpacing: '-.8px', lineHeight: 1 }}>
              {totalSolved}
              <span style={{ fontSize: 16, color: 'var(--text-3)', fontWeight: 500 }}> / {totalAll}</span>
            </div>
            <div className="mono" style={{ fontSize: 11, color: 'var(--text-3)', marginTop: 4 }}>
              Striver A2Z · 18 sections
            </div>
          </div>
          <div style={{
            width: 56, height: 56, borderRadius: '50%', flexShrink: 0,
            background: 'var(--accent-soft)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <span className="disp" style={{ fontSize: 15, fontWeight: 700, color: 'var(--accent)' }}>
              {pct}%
            </span>
          </div>
        </div>
        <Progress pct={pct} h={8} />
        <div className="row" style={{ gap: 16, marginTop: 14 }}>
          {[
            { label: 'Easy',   count: 152, color: 'var(--emerald)' },
            { label: 'Medium', count: 186, color: 'var(--amber)' },
            { label: 'Hard',   count: 136, color: 'var(--red)' },
          ].map(d => (
            <div key={d.label} className="row" style={{ gap: 5 }}>
              <div style={{ width: 8, height: 8, borderRadius: '50%', background: d.color }} />
              <span className="mono" style={{ fontSize: 10.5, color: 'var(--text-3)' }}>
                {d.count} {d.label}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Section list */}
      {STRIVER_SECTIONS.map(s => (
        <StriverSectionCard key={s.id} section={s} onPress={onSectionPress} />
      ))}
    </div>
  );
}

/* ── Mode toggle ──────────────────────────────────────────── */
function RoadmapModeToggle({ mode, onChange }) {
  return (
    <div style={{
      display: 'flex', gap: 4, padding: '4px',
      background: 'var(--surface-2)', border: '1px solid var(--border)',
      borderRadius: 16, marginBottom: 20,
    }}>
      {[
        { id: 'custom',  label: 'Custom' },
        { id: 'striver', label: 'Striver A2Z' },
      ].map(opt => {
        const on = mode === opt.id;
        return (
          <button key={opt.id} className="tap" onClick={() => onChange(opt.id)} style={{
            flex: 1, padding: '9px 0', borderRadius: 12,
            fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 600,
            background: on ? 'var(--surface-3)' : 'transparent',
            color: on ? (opt.id === 'striver' ? 'var(--accent)' : 'var(--text-1)') : 'var(--text-3)',
            border: on ? '1px solid var(--border)' : '1px solid transparent',
            transition: 'all .18s ease',
          }}>{opt.label}</button>
        );
      })}
    </div>
  );
}

/* ── Screen root ──────────────────────────────────────────── */
function RoadmapScreen({ onTopicPress }) {
  const [mode, setMode] = React.useState('custom');

  return (
    <div className="screen animate-in">
      {/* Header */}
      <div style={{ padding: '14px 2px 18px' }}>
        <div className="eyebrow">Your path</div>
        <div className="disp" style={{ fontSize: 28, fontWeight: 700, letterSpacing: '-.8px', marginTop: 4 }}>
          Roadmap
        </div>
      </div>

      {/* Mode toggle */}
      <RoadmapModeToggle mode={mode} onChange={setMode} />

      {/* Content */}
      <div className="animate-in" key={mode}>
        {mode === 'custom'
          ? <CustomRoadmap onTopicPress={onTopicPress} />
          : <StriverRoadmap onSectionPress={() => {}} />
        }
      </div>
    </div>
  );
}

Object.assign(window, { RoadmapScreen });
