/* screen_review.jsx — SRS Review Queue */

function ReviewCard({ p, onStart }) {
  const isOverdue = p.overdueDays > 0;
  const urgentColor = p.overdueDays > 1 ? 'var(--red)' : 'var(--amber)';
  const dueColor    = isOverdue ? urgentColor : 'var(--emerald)';

  return (
    <div className="card tap" onClick={() => onStart(p)} style={{
      padding: '16px 18px', marginBottom: 10, cursor: 'pointer',
      borderColor: isOverdue
        ? 'color-mix(in oklch, ' + urgentColor + ' 30%, transparent)'
        : 'var(--border)',
    }}>
      <div className="row" style={{ gap: 12 }}>
        {/* Status dot */}
        <div style={{
          width: 8, height: 8, borderRadius: '50%', flexShrink: 0,
          marginTop: 8, alignSelf: 'flex-start',
          background: dueColor,
          boxShadow: '0 0 0 4px color-mix(in oklch, ' + dueColor + ' 16%, transparent)',
        }} />

        <div style={{ flex: 1, minWidth: 0 }}>
          <div className="row" style={{ justifyContent: 'space-between', gap: 8 }}>
            <span className="disp" style={{
              fontSize: 15.5, fontWeight: 600, letterSpacing: '-.2px',
              overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
            }}>{p.name}</span>
            <span className="mono" style={{
              fontSize: 11, fontWeight: 600, flexShrink: 0,
              color: dueColor,
            }}>
              {isOverdue ? `${p.overdueDays}d overdue` : 'Due today'}
            </span>
          </div>

          <div className="row" style={{ gap: 8, marginTop: 10, flexWrap: 'wrap' }}>
            <Difficulty level={p.difficulty} />
            <span className="mono" style={{
              fontSize: 11, color: 'var(--text-2)',
              padding: '4px 8px', background: 'var(--surface-3)', borderRadius: 8,
            }}>{p.topic}</span>
            <span className="mono" style={{ fontSize: 11, color: 'var(--text-3)' }}>{p.pattern}</span>
          </div>

          {/* Last confidence dots */}
          <div className="row" style={{ gap: 4, marginTop: 10 }}>
            <span className="mono" style={{ fontSize: 10, color: 'var(--text-3)', marginRight: 4 }}>Last:</span>
            {[1,2,3,4,5].map(n => (
              <div key={n} style={{
                width: 7, height: 7, borderRadius: '50%',
                background: n <= p.lastConf ? 'var(--accent)' : 'var(--surface-3)',
                border: n <= p.lastConf ? 'none' : '1px solid var(--border-strong)',
              }} />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

/* ── Review modal (shown when tapping a card) ─────────────── */
function ReviewModal({ p, open, onClose, onDone }) {
  const [conf, setConf]               = React.useState(3);
  const [keepRetrying, setKeepRetrying] = React.useState(true);

  React.useEffect(() => {
    if (p) setConf(p.lastConf);
  }, [p]);

  const confLabels = ['', 'Still shaky', 'Getting there', 'Comfortable', 'Confident', 'Nailed it'];

  if (!open || !p) return null;

  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 40 }}>
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0,
        background: 'rgba(0,0,0,.6)',
        animation: 'fadeIn .22s ease both',
      }} />
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        background: 'var(--surface-1)',
        borderRadius: '28px 28px 0 0',
        border: '1px solid var(--border)', borderBottom: 'none',
        animation: 'sheetIn .36s cubic-bezier(.22,.61,.36,1) both',
        boxShadow: '0 -20px 60px rgba(0,0,0,.5)',
        padding: '12px 22px 40px',
      }}>
        {/* Handle */}
        <div style={{
          width: 40, height: 5, borderRadius: 3,
          background: 'var(--border-strong)', margin: '0 auto 20px',
        }} />

        {/* Problem header */}
        <div className="row" style={{ gap: 12, marginBottom: 22 }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div className="eyebrow" style={{ marginBottom: 5 }}>Reviewing</div>
            <div className="disp" style={{
              fontSize: 20, fontWeight: 700, letterSpacing: '-.4px', lineHeight: 1.2,
            }}>{p.name}</div>
            <div className="row" style={{ gap: 8, marginTop: 10 }}>
              <Difficulty level={p.difficulty} />
              <span className="mono" style={{ fontSize: 11, color: 'var(--text-2)' }}>{p.pattern}</span>
            </div>
          </div>
          {/* Open problem link */}
          <div style={{
            width: 42, height: 42, borderRadius: 13, flexShrink: 0,
            background: 'var(--surface-3)', color: 'var(--text-2)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <IconArrowRight size={20} />
          </div>
        </div>

        {/* Confidence picker */}
        <div style={{
          padding: '16px 16px', borderRadius: 16,
          background: 'var(--surface-2)', border: '1px solid var(--border)', marginBottom: 14,
        }}>
          <div className="row" style={{ justifyContent: 'space-between', marginBottom: 14 }}>
            <span className="eyebrow">How did it go?</span>
            <span className="mono" style={{ fontSize: 12, fontWeight: 600, color: 'var(--accent)' }}>
              {confLabels[conf]}
            </span>
          </div>
          <div className="row" style={{ justifyContent: 'space-between', alignItems: 'center' }}>
            <Confidence value={conf} onChange={setConf} mode="stars" size={30} gap={8} />
            <span className="disp" style={{ fontSize: 16, fontWeight: 700, color: 'var(--accent)' }}>
              {conf}/5
            </span>
          </div>
        </div>

        {/* Keep re-attempting toggle */}
        <button className="tap" onClick={() => setKeepRetrying(v => !v)} style={{
          width: '100%', padding: '13px 16px', borderRadius: 14, marginBottom: 18,
          background: keepRetrying ? 'var(--accent-soft)' : 'var(--surface-2)',
          border: '1px solid ' + (keepRetrying ? 'var(--accent-line)' : 'var(--border)'),
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          color: 'var(--text-1)',
        }}>
          <div style={{ textAlign: 'left' }}>
            <div className="disp" style={{
              fontSize: 14, fontWeight: 600,
              color: keepRetrying ? 'var(--accent)' : 'var(--text-1)',
            }}>Keep re-attempting</div>
            <div className="mono" style={{ fontSize: 11, color: 'var(--text-3)', marginTop: 2 }}>
              Schedule another review session
            </div>
          </div>
          {/* Toggle pill */}
          <div style={{
            width: 42, height: 24, borderRadius: 12, flexShrink: 0,
            background: keepRetrying ? 'var(--accent)' : 'var(--surface-3)',
            position: 'relative', transition: 'background .2s',
          }}>
            <div style={{
              position: 'absolute', top: 3,
              left: keepRetrying ? 21 : 3,
              width: 18, height: 18, borderRadius: '50%',
              background: '#fff',
              transition: 'left .22s cubic-bezier(.22,.61,.36,1)',
              boxShadow: '0 1px 4px rgba(0,0,0,.25)',
            }} />
          </div>
        </button>

        <button className="tap" onClick={() => onDone(p, conf, keepRetrying)} style={{
          width: '100%', height: 54, borderRadius: 17,
          background: 'var(--accent)', color: 'var(--on-accent)',
          fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 16,
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        }}>
          <IconCheck size={20} /> Log Review
        </button>
      </div>
    </div>
  );
}

/* ── Screen root ──────────────────────────────────────────── */
function ReviewScreen({ onBack }) {
  const [queue, setQueue]       = React.useState(REVIEW_QUEUE);
  const [reviewing, setReviewing] = React.useState(null);

  const overdue = queue.filter(p => p.overdueDays > 0);
  const dueToday = queue.filter(p => p.overdueDays === 0);
  const sorted = [...overdue].sort((a,b) => b.overdueDays - a.overdueDays).concat(dueToday);

  const handleDone = (p, conf, keepRetrying) => {
    if (!keepRetrying) setQueue(q => q.filter(x => x.id !== p.id));
    setReviewing(null);
  };

  return (
    <div style={{ position: 'relative', height: '100%' }}>
      <div className="screen animate-in" style={{ paddingTop: 14 }}>

        {/* Header */}
        <div className="row" style={{ gap: 14, padding: '0 2px 22px' }}>
          <button className="tap" onClick={onBack} style={{
            width: 38, height: 38, borderRadius: 12,
            background: 'var(--surface-2)', border: '1px solid var(--border)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            color: 'var(--text-2)', flexShrink: 0,
          }}>
            <IconBack size={20} />
          </button>
          <div>
            <div className="eyebrow">Spaced repetition</div>
            <div className="disp" style={{ fontSize: 22, fontWeight: 700, letterSpacing: '-.5px', marginTop: 3 }}>
              Review Queue
            </div>
          </div>
        </div>

        {/* Stats */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 10, marginBottom: 22 }}>
          {[
            { label: 'Overdue',   value: overdue.length,  color: 'var(--red)' },
            { label: 'Due Today', value: dueToday.length, color: 'var(--amber)' },
            { label: 'Total',     value: queue.length,    color: 'var(--text-2)' },
          ].map(s => (
            <div key={s.label} className="card" style={{ padding: '13px 14px' }}>
              <div className="mono" style={{
                fontSize: 10, color: s.color,
                textTransform: 'uppercase', letterSpacing: '.6px',
              }}>{s.label}</div>
              <div className="disp" style={{
                fontSize: 26, fontWeight: 700, letterSpacing: '-.6px', marginTop: 6,
              }}>{s.value}</div>
            </div>
          ))}
        </div>

        {/* Queue list */}
        {sorted.map(p => <ReviewCard key={p.id} p={p} onStart={setReviewing} />)}

        {/* Empty state */}
        {queue.length === 0 && (
          <div style={{ textAlign: 'center', padding: '60px 20px' }}>
            <div style={{
              width: 72, height: 72, borderRadius: 24, margin: '0 auto 20px',
              background: 'var(--emerald-soft)', color: 'var(--emerald)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <IconCheck size={36} sw={2} />
            </div>
            <div className="disp" style={{ fontSize: 20, fontWeight: 700 }}>All caught up!</div>
            <div className="mono" style={{ fontSize: 12, color: 'var(--text-3)', marginTop: 8, lineHeight: 1.6 }}>
              No reviews due right now.{'\n'}Check back tomorrow.
            </div>
          </div>
        )}
      </div>

      <ReviewModal
        p={reviewing}
        open={!!reviewing}
        onClose={() => setReviewing(null)}
        onDone={handleDone}
      />
    </div>
  );
}

Object.assign(window, { ReviewScreen });
