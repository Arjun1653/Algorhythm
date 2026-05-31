/* screen_detail.jsx — Problem detail view */

function StatusBadge({ status }) {
  const meta = {
    solved:    { label: 'Solved',       color: 'var(--emerald)', soft: 'var(--emerald-soft)' },
    review:    { label: 'Needs Review', color: 'var(--amber)',   soft: 'var(--amber-soft)' },
    attempted: { label: 'Attempted',    color: 'var(--text-3)',  soft: 'var(--surface-3)' },
    unsolved:  { label: 'Unsolved',     color: 'var(--text-3)',  soft: 'var(--surface-3)' },
  };
  const m = meta[status] || meta.unsolved;
  return (
    <span className="mono" style={{
      fontSize: 11, fontWeight: 600, padding: '5px 11px', borderRadius: 10,
      color: m.color, background: m.soft,
    }}>{m.label}</span>
  );
}

function PatternTag({ label }) {
  return (
    <span className="mono" style={{
      fontSize: 11, fontWeight: 500, padding: '5px 10px', borderRadius: 10,
      color: 'var(--text-2)', background: 'var(--surface-3)',
      border: '1px solid var(--border)',
    }}>{label}</span>
  );
}

function ComplexityBadge({ label, value }) {
  return (
    <div style={{
      flex: 1, padding: '12px 14px', borderRadius: 14,
      background: 'var(--surface-3)', border: '1px solid var(--border)',
    }}>
      <div className="mono" style={{ fontSize: 10, color: 'var(--text-3)', textTransform: 'uppercase', letterSpacing: '.6px' }}>
        {label}
      </div>
      <div className="mono" style={{ fontSize: 15, fontWeight: 600, color: 'var(--accent)', marginTop: 5 }}>
        {value}
      </div>
    </div>
  );
}

function ReviewHistoryEntry({ entry, isLast }) {
  const confColors = ['', 'var(--red)', 'var(--red)', 'var(--amber)', 'var(--emerald)', 'var(--emerald)'];
  return (
    <div style={{ display: 'flex', gap: 14 }}>
      {/* Timeline rail */}
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', width: 20 }}>
        <div style={{
          width: 10, height: 10, borderRadius: '50%', flexShrink: 0,
          background: confColors[entry.conf] || 'var(--text-3)',
          border: '2px solid var(--surface-2)',
          boxShadow: '0 0 0 2px ' + (confColors[entry.conf] || 'var(--text-3)') + '33',
        }} />
        {!isLast && <div style={{ width: 2, flex: 1, minHeight: 20, background: 'var(--border)', marginTop: 4 }} />}
      </div>
      {/* Entry content */}
      <div style={{ flex: 1, paddingBottom: isLast ? 0 : 16 }}>
        <div className="row" style={{ justifyContent: 'space-between', marginBottom: 4 }}>
          <span className="mono" style={{ fontSize: 12, fontWeight: 600, color: confColors[entry.conf] }}>
            {entry.label}
          </span>
          <span className="mono" style={{ fontSize: 11, color: 'var(--text-3)' }}>{entry.date}</span>
        </div>
        <div style={{ display: 'flex', gap: 3 }}>
          {[1,2,3,4,5].map(n => (
            <div key={n} style={{
              width: 6, height: 6, borderRadius: '50%',
              background: n <= entry.conf ? confColors[entry.conf] : 'var(--surface-3)',
            }} />
          ))}
        </div>
      </div>
    </div>
  );
}

/* ── Screen root ──────────────────────────────────────────── */
function DetailScreen({ problem = PROBLEM_DETAIL, onBack }) {
  const [notes, setNotes] = React.useState(problem.notes || '');
  const [editing, setEditing] = React.useState(false);

  return (
    <div style={{ position: 'relative', height: '100%' }}>
      <div className="screen animate-in" style={{ paddingTop: 10 }}>

        {/* Top bar */}
        <div className="row" style={{ gap: 12, padding: '4px 2px 20px', justifyContent: 'space-between' }}>
          <button className="tap" onClick={onBack} style={{
            width: 38, height: 38, borderRadius: 12, flexShrink: 0,
            background: 'var(--surface-2)', border: '1px solid var(--border)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            color: 'var(--text-2)',
          }}>
            <IconBack size={20} />
          </button>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div className="disp" style={{
              fontSize: 17, fontWeight: 700, letterSpacing: '-.3px',
              overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
            }}>{problem.name}</div>
          </div>
          <div className="row" style={{ gap: 8, flexShrink: 0 }}>
            <button className="tap" style={{
              width: 38, height: 38, borderRadius: 12,
              background: 'var(--surface-2)', border: '1px solid var(--border)',
              display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-2)',
            }}>
              <IconBookmark size={18} />
            </button>
            <button className="tap" style={{
              width: 38, height: 38, borderRadius: 12,
              background: 'var(--surface-2)', border: '1px solid var(--border)',
              display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-2)',
            }}>
              <IconEdit size={18} />
            </button>
          </div>
        </div>

        {/* Meta chips */}
        <div className="row" style={{ gap: 8, flexWrap: 'wrap', marginBottom: 20 }}>
          <Difficulty level={problem.difficulty} />
          <span className="mono" style={{
            fontSize: 11, fontWeight: 600, padding: '4px 10px', borderRadius: 8,
            color: 'var(--text-2)', background: 'var(--surface-3)',
          }}>{problem.platform}</span>
          <StatusBadge status={problem.status} />
        </div>

        {/* Topic + patterns */}
        <div className="card" style={{ padding: '16px 18px', marginBottom: 14 }}>
          <div className="eyebrow" style={{ marginBottom: 12 }}>Topic & Patterns</div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
            <span className="mono" style={{
              fontSize: 12, fontWeight: 600, padding: '5px 11px', borderRadius: 10,
              color: 'var(--accent)', background: 'var(--accent-soft)',
              border: '1px solid var(--accent-line)',
            }}>{problem.topic}</span>
            {problem.patterns.map(p => <PatternTag key={p} label={p} />)}
          </div>
        </div>

        {/* Confidence */}
        <div className="card" style={{ padding: '16px 18px', marginBottom: 14 }}>
          <div className="row" style={{ justifyContent: 'space-between', marginBottom: 12 }}>
            <div className="eyebrow">Confidence</div>
            <span className="mono" style={{ fontSize: 11, color: 'var(--accent)', fontWeight: 600 }}>
              {['', 'Shaky', 'Learning', 'Comfortable', 'Confident', 'Mastered'][problem.conf]}
            </span>
          </div>
          <div className="row" style={{ justifyContent: 'space-between' }}>
            <Confidence value={problem.conf} readOnly size={26} gap={8} />
            <span className="disp" style={{ fontSize: 16, fontWeight: 700, color: 'var(--accent)' }}>
              {problem.conf}/5
            </span>
          </div>
        </div>

        {/* Complexities */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 14 }}>
          <ComplexityBadge label="Time"  value={problem.timeComplexity} />
          <ComplexityBadge label="Space" value={problem.spaceComplexity} />
        </div>

        {/* Next review */}
        <div style={{
          padding: '12px 16px', borderRadius: 14, marginBottom: 14,
          background: 'var(--amber-soft)',
          border: '1px solid color-mix(in oklch, var(--amber) 24%, transparent)',
          display: 'flex', alignItems: 'center', gap: 10,
        }}>
          <span style={{ color: 'var(--amber)', display: 'flex', flexShrink: 0 }}><IconClock size={18} /></span>
          <div>
            <div className="mono" style={{ fontSize: 11, color: 'var(--amber)', fontWeight: 600 }}>
              Next review
            </div>
            <div className="disp" style={{ fontSize: 13, fontWeight: 600, marginTop: 2 }}>
              {problem.nextReview}
            </div>
          </div>
        </div>

        {/* Notes */}
        <div className="card" style={{ padding: '16px 18px', marginBottom: 14 }}>
          <div className="row" style={{ justifyContent: 'space-between', marginBottom: 12 }}>
            <div className="eyebrow">My notes</div>
            <button className="tap" onClick={() => setEditing(e => !e)} style={{
              color: 'var(--accent)', fontFamily: 'var(--font-mono)', fontSize: 11, fontWeight: 600,
            }}>
              {editing ? 'Done' : 'Edit'}
            </button>
          </div>
          {editing ? (
            <textarea
              value={notes}
              onChange={e => setNotes(e.target.value)}
              placeholder="Write your approach, key insight, or gotcha…"
              style={{
                width: '100%', minHeight: 100, border: 'none', outline: 'none',
                background: 'var(--surface-3)', color: 'var(--text-1)',
                fontFamily: 'var(--font-body)', fontSize: 13.5, lineHeight: 1.65,
                borderRadius: 12, padding: 12, resize: 'none', boxSizing: 'border-box',
              }}
            />
          ) : (
            <div style={{
              fontSize: 13.5, color: notes ? 'var(--text-1)' : 'var(--text-3)',
              lineHeight: 1.65, fontStyle: notes ? 'normal' : 'italic',
            }}>
              {notes || 'No notes yet — tap Edit to add your approach.'}
            </div>
          )}
        </div>

        {/* Review history */}
        {problem.reviewHistory && problem.reviewHistory.length > 0 && (
          <div className="card" style={{ padding: '16px 18px', marginBottom: 14 }}>
            <div className="eyebrow" style={{ marginBottom: 16 }}>Review history</div>
            {problem.reviewHistory.map((entry, i) => (
              <ReviewHistoryEntry
                key={i}
                entry={entry}
                isLast={i === problem.reviewHistory.length - 1}
              />
            ))}
          </div>
        )}

        {/* Footer actions */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 8 }}>
          <button className="tap" style={{
            flex: 1, height: 50, borderRadius: 16,
            background: 'var(--surface-2)', border: '1px solid var(--border)',
            color: 'var(--red)', fontFamily: 'var(--font-display)', fontWeight: 600, fontSize: 14,
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 7,
          }}>
            <IconTrash size={17} /> Delete
          </button>
          <button className="tap" style={{
            flex: 2, height: 50, borderRadius: 16,
            background: 'var(--accent)', color: 'var(--on-accent)',
            fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 15,
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
          }}>
            <IconRepeat size={18} /> Re-attempt
          </button>
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { DetailScreen });
