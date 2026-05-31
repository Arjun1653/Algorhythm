/* data.jsx — sample data for all screens */

/* ── Core problem log ─────────────────────────────────────── */
const PROBLEMS = [
  { id: 1,  name: 'Two Sum',                              platform: 'LeetCode',   difficulty: 'easy',   topic: 'Arrays & Hashing',      pattern: 'Hash Map',          status: 'solved',    conf: 5, time: 'O(n)',       when: '2h ago' },
  { id: 2,  name: 'Longest Substring Without Repeating',  platform: 'LeetCode',   difficulty: 'medium', topic: 'Sliding Window',         pattern: 'Sliding Window',    status: 'solved',    conf: 3, time: 'O(n)',       when: 'Yesterday' },
  { id: 3,  name: 'Merge K Sorted Lists',                 platform: 'LeetCode',   difficulty: 'hard',   topic: 'Linked Lists',           pattern: 'Heap / Merge',      status: 'review',    conf: 2, time: 'O(n log k)', when: 'Yesterday' },
  { id: 4,  name: 'Valid Parentheses',                    platform: 'LeetCode',   difficulty: 'easy',   topic: 'Stack',                  pattern: 'Stack',             status: 'solved',    conf: 5, time: 'O(n)',       when: '2d ago' },
  { id: 5,  name: 'Course Schedule',                      platform: 'LeetCode',   difficulty: 'medium', topic: 'Graphs',                 pattern: 'Topological Sort',  status: 'review',    conf: 2, time: 'O(V+E)',     when: '3d ago' },
  { id: 6,  name: 'Number of Islands',                    platform: 'LeetCode',   difficulty: 'medium', topic: 'Graphs',                 pattern: 'DFS / BFS',         status: 'solved',    conf: 4, time: 'O(mn)',      when: '3d ago' },
  { id: 7,  name: 'Word Ladder',                          platform: 'LeetCode',   difficulty: 'hard',   topic: 'Graphs',                 pattern: 'BFS',               status: 'attempted', conf: 1, time: 'O(n·k²)',    when: '4d ago' },
  { id: 8,  name: 'Coin Change',                          platform: 'LeetCode',   difficulty: 'medium', topic: '1-D DP',                 pattern: 'Dynamic Prog.',     status: 'review',    conf: 3, time: 'O(n·a)',     when: '5d ago' },
  { id: 9,  name: 'Maximum Depth of Binary Tree',         platform: 'LeetCode',   difficulty: 'easy',   topic: 'Trees',                  pattern: 'DFS',               status: 'solved',    conf: 5, time: 'O(n)',       when: '6d ago' },
  { id: 10, name: 'Find Median from Data Stream',         platform: 'LeetCode',   difficulty: 'hard',   topic: 'Heap / Priority Queue',  pattern: 'Two Heaps',         status: 'attempted', conf: 1, time: 'O(log n)',   when: '1w ago' },
];

/* ── Roadmap topics (Custom Mode) ─────────────────────────── */
const ROADMAP = [
  { name: 'Arrays & Hashing',       solved: 18, total: 18, est: 18, state: 'done' },
  { name: 'Two Pointers',           solved: 9,  total: 12, est: 12, state: 'active' },
  { name: 'Sliding Window',         solved: 4,  total: 10, est: 10, state: 'active' },
  { name: 'Stack',                  solved: 0,  total: 9,  est: 9,  state: 'unlocked' },
  { name: 'Binary Search',          solved: 0,  total: 11, est: 11, state: 'unlocked' },
  { name: 'Linked Lists',           solved: 0,  total: 13, est: 13, state: 'locked' },
  { name: 'Trees',                  solved: 0,  total: 16, est: 16, state: 'locked' },
  { name: 'Tries',                  solved: 0,  total: 6,  est: 6,  state: 'locked' },
  { name: 'Heap / Priority Queue',  solved: 0,  total: 8,  est: 8,  state: 'locked' },
  { name: 'Backtracking',           solved: 0,  total: 10, est: 10, state: 'locked' },
  { name: '1-D Dynamic Programming',solved: 0,  total: 14, est: 14, state: 'locked' },
  { name: '2-D Dynamic Programming',solved: 0,  total: 11, est: 11, state: 'locked' },
  { name: 'Graphs',                 solved: 0,  total: 15, est: 15, state: 'locked' },
  { name: 'Advanced Graphs',        solved: 0,  total: 9,  est: 9,  state: 'locked' },
];

/* ── Striver A2Z sections (Striver Mode) ──────────────────── */
const STRIVER_SECTIONS = [
  { id: 1,  name: 'Learn the Basics',                    total: 54, solved: 32, active: true  },
  { id: 2,  name: 'Sorting Techniques',                  total: 7,  solved: 7,  active: false },
  { id: 3,  name: 'Arrays [Easy → Hard]',                total: 40, solved: 18, active: false },
  { id: 4,  name: 'Binary Search',                       total: 32, solved: 0,  active: false },
  { id: 5,  name: 'Strings [Basic and Medium]',          total: 15, solved: 0,  active: false },
  { id: 6,  name: 'Linked Lists',                        total: 31, solved: 0,  active: false },
  { id: 7,  name: 'Recursion [Pattern-wise]',            total: 25, solved: 0,  active: false },
  { id: 8,  name: 'Bit Manipulation',                    total: 18, solved: 0,  active: false },
  { id: 9,  name: 'Stacks and Queues',                   total: 30, solved: 0,  active: false },
  { id: 10, name: 'Sliding Window & Two Pointer',        total: 12, solved: 0,  active: false },
  { id: 11, name: 'Heaps',                               total: 17, solved: 0,  active: false },
  { id: 12, name: 'Greedy Algorithms',                   total: 15, solved: 0,  active: false },
  { id: 13, name: 'Binary Trees',                        total: 38, solved: 0,  active: false },
  { id: 14, name: 'Binary Search Trees',                 total: 16, solved: 0,  active: false },
  { id: 15, name: 'Graphs',                              total: 53, solved: 0,  active: false },
  { id: 16, name: 'Dynamic Programming',                 total: 55, solved: 0,  active: false },
  { id: 17, name: 'Tries',                               total: 7,  solved: 0,  active: false },
  { id: 18, name: 'Strings Part 2 (Advanced)',           total: 9,  solved: 0,  active: false },
];

/* ── SRS Review Queue ─────────────────────────────────────── */
const REVIEW_QUEUE = [
  { id: 10, name: 'Find Median from Data Stream', difficulty: 'hard',   topic: 'Heap / Priority Queue', pattern: 'Two Heaps',        overdueDays: 3, lastConf: 1, url: 'https://leetcode.com/problems/find-median-from-data-stream/' },
  { id: 3,  name: 'Merge K Sorted Lists',         difficulty: 'hard',   topic: 'Linked Lists',          pattern: 'Heap / Merge',     overdueDays: 2, lastConf: 2, url: 'https://leetcode.com/problems/merge-k-sorted-lists/' },
  { id: 8,  name: 'Coin Change',                  difficulty: 'medium', topic: '1-D DP',                pattern: 'Dynamic Prog.',    overdueDays: 1, lastConf: 3, url: 'https://leetcode.com/problems/coin-change/' },
  { id: 5,  name: 'Course Schedule',              difficulty: 'medium', topic: 'Graphs',                pattern: 'Topological Sort', overdueDays: 0, lastConf: 2, url: 'https://leetcode.com/problems/course-schedule/' },
  { id: 7,  name: 'Word Ladder',                  difficulty: 'hard',   topic: 'Graphs',                pattern: 'BFS',              overdueDays: 0, lastConf: 1, url: 'https://leetcode.com/problems/word-ladder/' },
];

/* ── Problem detail (extended view for id=3) ──────────────── */
const PROBLEM_DETAIL = {
  id: 3,
  name: 'Merge K Sorted Lists',
  platform: 'LeetCode',
  difficulty: 'hard',
  status: 'review',
  topic: 'Linked Lists',
  patterns: ['Heap / Merge', 'Divide & Conquer'],
  conf: 2,
  timeComplexity: 'O(n log k)',
  spaceComplexity: 'O(k)',
  url: 'https://leetcode.com/problems/merge-k-sorted-lists/',
  notes: 'Use a min-heap of size k. Pop the min node each time and push its next. Watch for null next pointers — push only when node.next exists.',
  dateSolved: 'May 29, 2026',
  nextReview: 'Overdue by 2 days',
  reviewHistory: [
    { date: 'May 30', conf: 2, label: 'Learning' },
    { date: 'May 28', conf: 1, label: 'Shaky' },
    { date: 'May 24', conf: 1, label: 'Shaky' },
  ],
};

/* ── Analytics mastery ────────────────────────────────────── */
const MASTERY = [
  { name: 'Arrays & Hashing',  pct: 100, level: 'strong' },
  { name: 'Two Pointers',      pct: 75,  level: 'strong' },
  { name: 'Stack',             pct: 68,  level: 'ok' },
  { name: 'Sliding Window',    pct: 40,  level: 'ok' },
  { name: 'Dynamic Prog.',     pct: 28,  level: 'weak' },
  { name: 'Graphs',            pct: 22,  level: 'weak' },
];

/* ── Cheatsheet content ───────────────────────────────────── */
const CHEATSHEETS = {
  'Arrays & Hashing': {
    concept: 'Arrays store elements at contiguous memory locations enabling O(1) index access. Hash maps provide O(1) average-time lookup by mapping keys to indices via a hash function. Together they solve frequency, duplicate, and grouping problems in linear time.',
    patterns: [
      { name: 'Frequency Count',    cue: 'Count occurrences, top-K frequent, anagram check' },
      { name: 'Two-pass Prefix',    cue: 'Range sum queries, subarray sum = target' },
      { name: 'Group by Signature', cue: 'Group anagrams — sort chars as key' },
    ],
    timeComplexity: 'O(n)',
    spaceComplexity: 'O(n)',
    complexityNote: 'HashMap ops are O(1) amortised',
    snippet: 'freq = {}\nfor x in arr:\n    freq[x] = freq.get(x, 0) + 1\n\n# prefix sum\npre = [0] * (n + 1)\nfor i, x in enumerate(arr):\n    pre[i+1] = pre[i] + x',
    mistakes: [
      'Forgetting to handle empty input edge case',
      'Using == to compare arrays inside a map key — use tuple/string instead',
      'Off-by-one in prefix sum indexing (pre[i+1] vs pre[i])',
    ],
  },
  'Two Pointers': {
    concept: 'Two pointers is a technique where two indices traverse a data structure — often from both ends or at different speeds — to reduce an O(n²) brute force to O(n). Works best on sorted arrays or problems with a shrink/expand condition.',
    patterns: [
      { name: 'Opposite Ends',  cue: 'Pair sum = target, palindrome check, container water' },
      { name: 'Fast / Slow',    cue: 'Cycle detection in linked list, middle of list' },
      { name: 'Partition',      cue: 'Remove duplicates in-place, move zeroes' },
    ],
    timeComplexity: 'O(n)',
    spaceComplexity: 'O(1)',
    complexityNote: 'In-place — no extra space beyond two index vars',
    snippet: 'l, r = 0, len(arr) - 1\nwhile l < r:\n    s = arr[l] + arr[r]\n    if s == target: return [l, r]\n    elif s < target: l += 1\n    else: r -= 1',
    mistakes: [
      'Not sorting first when the problem requires sorted order',
      'loop condition l < r vs l <= r — off-by-one causes missed pairs',
      'Moving both pointers at once instead of one at a time',
    ],
  },
  'Sliding Window': {
    concept: 'Sliding window maintains a contiguous subarray/substring of variable or fixed size. A right pointer expands the window; a left pointer contracts it when a constraint is violated. Converts O(n²) substring problems to O(n).',
    patterns: [
      { name: 'Fixed size k',       cue: 'Max sum subarray of size k, sliding average' },
      { name: 'Variable shrink',    cue: 'Longest substring without repeat, min window substring' },
      { name: 'At-most-k variant',  cue: 'Subarrays with at most k distinct: use two windows' },
    ],
    timeComplexity: 'O(n)',
    spaceComplexity: 'O(k)',
    complexityNote: 'k = window size or alphabet size for char frequency maps',
    snippet: 'l = 0\nfreq = {}\nres = 0\nfor r, c in enumerate(s):\n    freq[c] = freq.get(c, 0) + 1\n    while len(freq) > k:        # shrink\n        freq[s[l]] -= 1\n        if freq[s[l]] == 0: del freq[s[l]]\n        l += 1\n    res = max(res, r - l + 1)\nreturn res',
    mistakes: [
      'Forgetting to remove key from map when its count drops to 0',
      'Using fixed-size logic when the window should be variable',
      'Not resetting window state when breaking out of inner while',
    ],
  },
};

/* ── Search catalog (design sample — real JSON: 900+ problems) */
const CATALOG = [
  // ── Striver A2Z ────────────────────────────────────────────
  { id: 's1',  name: 'Sort an Array',                          src: 'Striver A2Z', platform: 'LeetCode',   difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['Sorting'],            url: 'https://leetcode.com/problems/sort-an-array/' },
  { id: 's2',  name: 'Find the Duplicate Number',              src: 'Striver A2Z', platform: 'LeetCode',   difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['Two Pointers','Cycle'],url: 'https://leetcode.com/problems/find-the-duplicate-number/' },
  { id: 's3',  name: 'Maximum Subarray',                       src: 'Striver A2Z', platform: 'LeetCode',   difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['Kadane'],             url: 'https://leetcode.com/problems/maximum-subarray/' },
  { id: 's4',  name: 'Merge Intervals',                        src: 'Striver A2Z', platform: 'LeetCode',   difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['Sorting'],            url: 'https://leetcode.com/problems/merge-intervals/' },
  { id: 's5',  name: 'Trapping Rain Water',                    src: 'Striver A2Z', platform: 'LeetCode',   difficulty: 'hard',   topic: 'Two Pointers',          patterns: ['Two Pointers'],       url: 'https://leetcode.com/problems/trapping-rain-water/' },
  { id: 's6',  name: 'Binary Search',                          src: 'Striver A2Z', platform: 'LeetCode',   difficulty: 'easy',   topic: 'Binary Search',         patterns: ['Binary Search'],      url: 'https://leetcode.com/problems/binary-search/' },
  { id: 's7',  name: 'Search in Rotated Sorted Array',         src: 'Striver A2Z', platform: 'LeetCode',   difficulty: 'medium', topic: 'Binary Search',         patterns: ['Binary Search'],      url: 'https://leetcode.com/problems/search-in-rotated-sorted-array/' },
  { id: 's8',  name: 'Reverse Linked List',                    src: 'Striver A2Z', platform: 'LeetCode',   difficulty: 'easy',   topic: 'Linked Lists',          patterns: ['Pointer Reversal'],   url: 'https://leetcode.com/problems/reverse-linked-list/' },
  { id: 's9',  name: 'Linked List Cycle',                      src: 'Striver A2Z', platform: 'LeetCode',   difficulty: 'easy',   topic: 'Linked Lists',          patterns: ['Fast / Slow'],        url: 'https://leetcode.com/problems/linked-list-cycle/' },
  { id: 's10', name: 'Merge K Sorted Lists',                   src: 'Striver A2Z', platform: 'LeetCode',   difficulty: 'hard',   topic: 'Linked Lists',          patterns: ['Heap / Merge'],       url: 'https://leetcode.com/problems/merge-k-sorted-lists/' },
  // ── NeetCode 150 ───────────────────────────────────────────
  { id: 'n1',  name: 'Two Sum',                                src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Hash Map'],           url: 'https://leetcode.com/problems/two-sum/' },
  { id: 'n2',  name: 'Contains Duplicate',                     src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Hash Set'],           url: 'https://leetcode.com/problems/contains-duplicate/' },
  { id: 'n3',  name: 'Valid Anagram',                          src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Hash Map'],           url: 'https://leetcode.com/problems/valid-anagram/' },
  { id: 'n4',  name: 'Group Anagrams',                         src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['Hash Map','Sorting'], url: 'https://leetcode.com/problems/group-anagrams/' },
  { id: 'n5',  name: 'Top K Frequent Elements',                src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['Hash Map','Bucket Sort'],url: 'https://leetcode.com/problems/top-k-frequent-elements/' },
  { id: 'n6',  name: 'Product of Array Except Self',           src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['Prefix Sum'],         url: 'https://leetcode.com/problems/product-of-array-except-self/' },
  { id: 'n7',  name: 'Longest Consecutive Sequence',           src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['Hash Set'],           url: 'https://leetcode.com/problems/longest-consecutive-sequence/' },
  { id: 'n8',  name: 'Valid Palindrome',                       src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: 'Two Pointers',          patterns: ['Two Pointers'],       url: 'https://leetcode.com/problems/valid-palindrome/' },
  { id: 'n9',  name: '3Sum',                                   src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Two Pointers',          patterns: ['Two Pointers','Sorting'],url: 'https://leetcode.com/problems/3sum/' },
  { id: 'n10', name: 'Container With Most Water',              src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Two Pointers',          patterns: ['Two Pointers'],       url: 'https://leetcode.com/problems/container-with-most-water/' },
  { id: 'n11', name: 'Best Time to Buy and Sell Stock',        src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: 'Sliding Window',        patterns: ['Sliding Window'],     url: 'https://leetcode.com/problems/best-time-to-buy-and-sell-stock/' },
  { id: 'n12', name: 'Longest Substring Without Repeating',   src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Sliding Window',        patterns: ['Sliding Window'],     url: 'https://leetcode.com/problems/longest-substring-without-repeating-characters/' },
  { id: 'n13', name: 'Minimum Window Substring',              src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'hard',   topic: 'Sliding Window',        patterns: ['Sliding Window'],     url: 'https://leetcode.com/problems/minimum-window-substring/' },
  { id: 'n14', name: 'Valid Parentheses',                      src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: 'Stack',                 patterns: ['Stack'],              url: 'https://leetcode.com/problems/valid-parentheses/' },
  { id: 'n15', name: 'Min Stack',                              src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Stack',                 patterns: ['Stack'],              url: 'https://leetcode.com/problems/min-stack/' },
  { id: 'n16', name: 'Binary Search',                          src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: 'Binary Search',         patterns: ['Binary Search'],      url: 'https://leetcode.com/problems/binary-search/' },
  { id: 'n17', name: 'Koko Eating Bananas',                    src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Binary Search',         patterns: ['Binary Search'],      url: 'https://leetcode.com/problems/koko-eating-bananas/' },
  { id: 'n18', name: 'Reverse Linked List',                    src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: 'Linked Lists',          patterns: ['Pointer Reversal'],   url: 'https://leetcode.com/problems/reverse-linked-list/' },
  { id: 'n19', name: 'LRU Cache',                              src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Linked Lists',          patterns: ['Hash Map','DLL'],     url: 'https://leetcode.com/problems/lru-cache/' },
  { id: 'n20', name: 'Invert Binary Tree',                     src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: 'Trees',                 patterns: ['DFS'],                url: 'https://leetcode.com/problems/invert-binary-tree/' },
  { id: 'n21', name: 'Maximum Depth of Binary Tree',           src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: 'Trees',                 patterns: ['DFS'],                url: 'https://leetcode.com/problems/maximum-depth-of-binary-tree/' },
  { id: 'n22', name: 'Lowest Common Ancestor of BST',          src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Trees',                 patterns: ['DFS'],                url: 'https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-search-tree/' },
  { id: 'n23', name: 'Binary Tree Level Order Traversal',      src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Trees',                 patterns: ['BFS'],                url: 'https://leetcode.com/problems/binary-tree-level-order-traversal/' },
  { id: 'n24', name: 'Course Schedule',                        src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Graphs',                patterns: ['Topological Sort'],   url: 'https://leetcode.com/problems/course-schedule/' },
  { id: 'n25', name: 'Number of Islands',                      src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Graphs',                patterns: ['DFS / BFS'],          url: 'https://leetcode.com/problems/number-of-islands/' },
  { id: 'n26', name: 'Clone Graph',                            src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: 'Graphs',                patterns: ['DFS','Hash Map'],     url: 'https://leetcode.com/problems/clone-graph/' },
  { id: 'n27', name: 'Climbing Stairs',                        src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'easy',   topic: '1-D DP',               patterns: ['Dynamic Prog.'],      url: 'https://leetcode.com/problems/climbing-stairs/' },
  { id: 'n28', name: 'Coin Change',                            src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: '1-D DP',               patterns: ['Dynamic Prog.'],      url: 'https://leetcode.com/problems/coin-change/' },
  { id: 'n29', name: 'Longest Increasing Subsequence',         src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'medium', topic: '1-D DP',               patterns: ['Dynamic Prog.'],      url: 'https://leetcode.com/problems/longest-increasing-subsequence/' },
  { id: 'n30', name: 'Find Median from Data Stream',           src: 'NeetCode 150',platform: 'LeetCode',   difficulty: 'hard',   topic: 'Heap / Priority Queue', patterns: ['Two Heaps'],          url: 'https://leetcode.com/problems/find-median-from-data-stream/' },
  // ── Blind 75 extras (not already in NeetCode 150) ──────────
  { id: 'b1',  name: 'Missing Number',                         src: 'Blind 75',    platform: 'LeetCode',   difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Bit Manipulation'],   url: 'https://leetcode.com/problems/missing-number/' },
  { id: 'b2',  name: 'Meeting Rooms',                          src: 'Blind 75',    platform: 'LeetCode',   difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Sorting'],            url: 'https://leetcode.com/problems/meeting-rooms/' },
  { id: 'b3',  name: 'Meeting Rooms II',                       src: 'Blind 75',    platform: 'LeetCode',   difficulty: 'medium', topic: 'Heap / Priority Queue', patterns: ['Greedy','Heap'],       url: 'https://leetcode.com/problems/meeting-rooms-ii/' },
  // ── Grind 75 extras ────────────────────────────────────────
  { id: 'g1',  name: 'Flood Fill',                             src: 'Grind 75',    platform: 'LeetCode',   difficulty: 'easy',   topic: 'Graphs',                patterns: ['DFS'],                url: 'https://leetcode.com/problems/flood-fill/' },
  { id: 'g2',  name: 'Implement Queue using Stacks',           src: 'Grind 75',    platform: 'LeetCode',   difficulty: 'easy',   topic: 'Stack',                 patterns: ['Stack'],              url: 'https://leetcode.com/problems/implement-queue-using-stacks/' },
  { id: 'g3',  name: 'First Bad Version',                      src: 'Grind 75',    platform: 'LeetCode',   difficulty: 'easy',   topic: 'Binary Search',         patterns: ['Binary Search'],      url: 'https://leetcode.com/problems/first-bad-version/' },
  // ── LC Top Interview 150 extras ────────────────────────────
  { id: 'l1',  name: 'Merge Sorted Array',                     src: 'LC Top 150',  platform: 'LeetCode',   difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Two Pointers'],       url: 'https://leetcode.com/problems/merge-sorted-array/' },
  { id: 'l2',  name: 'Remove Duplicates from Sorted Array',    src: 'LC Top 150',  platform: 'LeetCode',   difficulty: 'easy',   topic: 'Two Pointers',          patterns: ['Two Pointers'],       url: 'https://leetcode.com/problems/remove-duplicates-from-sorted-array/' },
  { id: 'l3',  name: 'Rotate Array',                           src: 'LC Top 150',  platform: 'LeetCode',   difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['In-place Reversal'],  url: 'https://leetcode.com/problems/rotate-array/' },
  { id: 'l4',  name: 'Spiral Matrix',                          src: 'LC Top 150',  platform: 'LeetCode',   difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['Simulation'],         url: 'https://leetcode.com/problems/spiral-matrix/' },
  { id: 'l5',  name: 'Jump Game',                              src: 'LC Top 150',  platform: 'LeetCode',   difficulty: 'medium', topic: '1-D DP',               patterns: ['Greedy'],             url: 'https://leetcode.com/problems/jump-game/' },
  // ── AlgoExpert 160 extras ──────────────────────────────────
  { id: 'a1',  name: 'Run-Length Encoding',                    src: 'AlgoExpert',  platform: 'AlgoExpert', difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['String Manip.'],      url: 'https://www.algoexpert.io/questions/run-length-encoding' },
  { id: 'a2',  name: 'Min Height BST',                         src: 'AlgoExpert',  platform: 'AlgoExpert', difficulty: 'medium', topic: 'Trees',                 patterns: ['DFS','Divide & Conquer'],url: 'https://www.algoexpert.io/questions/min-height-bst' },
  { id: 'a3',  name: 'River Sizes',                            src: 'AlgoExpert',  platform: 'AlgoExpert', difficulty: 'medium', topic: 'Graphs',                patterns: ['DFS'],                url: 'https://www.algoexpert.io/questions/river-sizes' },
  // ── Codeforces popular Div-2 A/B ───────────────────────────
  { id: 'cf1', name: 'Watermelon (4A)',                        src: 'Codeforces',  platform: 'Codeforces', difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Math'],               url: 'https://codeforces.com/problemset/problem/4/A' },
  { id: 'cf2', name: 'Way Too Long Words (71A)',               src: 'Codeforces',  platform: 'Codeforces', difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['String Manip.'],      url: 'https://codeforces.com/problemset/problem/71/A' },
  { id: 'cf3', name: 'Team (231A)',                            src: 'Codeforces',  platform: 'Codeforces', difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Simulation'],         url: 'https://codeforces.com/problemset/problem/231/A' },
  { id: 'cf4', name: 'Domino piling (1033A)',                  src: 'Codeforces',  platform: 'Codeforces', difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Greedy','Math'],      url: 'https://codeforces.com/problemset/problem/1033/A' },
  { id: 'cf5', name: 'Next Round (158A)',                      src: 'Codeforces',  platform: 'Codeforces', difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Binary Search'],      url: 'https://codeforces.com/problemset/problem/158/A' },
  // ── GFG Must-Do Interview problems ─────────────────────────
  { id: 'gf1', name: 'Kadane\'s Algorithm',                   src: 'GFG Must-Do', platform: 'GFG',        difficulty: 'medium', topic: 'Arrays & Hashing',      patterns: ['Kadane','DP'],        url: 'https://www.geeksforgeeks.org/largest-sum-contiguous-subarray/' },
  { id: 'gf2', name: 'Stock Buy and Sell',                    src: 'GFG Must-Do', platform: 'GFG',        difficulty: 'easy',   topic: 'Arrays & Hashing',      patterns: ['Greedy'],             url: 'https://www.geeksforgeeks.org/stock-buy-sell/' },
  { id: 'gf3', name: 'Detect Loop in Linked List',            src: 'GFG Must-Do', platform: 'GFG',        difficulty: 'easy',   topic: 'Linked Lists',          patterns: ['Fast / Slow'],        url: 'https://www.geeksforgeeks.org/detect-loop-in-a-linked-list/' },
  { id: 'gf4', name: 'Level Order Traversal',                 src: 'GFG Must-Do', platform: 'GFG',        difficulty: 'medium', topic: 'Trees',                 patterns: ['BFS'],                url: 'https://www.geeksforgeeks.org/level-order-tree-traversal/' },
  { id: 'gf5', name: 'Topological Sort',                      src: 'GFG Must-Do', platform: 'GFG',        difficulty: 'medium', topic: 'Graphs',                patterns: ['Topological Sort'],   url: 'https://www.geeksforgeeks.org/topological-sorting/' },
];

/* ── Picker options ───────────────────────────────────────── */
const PLATFORMS = ['LeetCode', 'Codeforces', 'GFG', 'NeetCode', 'AlgoExpert', 'HackerRank', 'Other'];
const TOPICS    = ['Arrays & Hashing', 'Two Pointers', 'Sliding Window', 'Stack', 'Binary Search', 'Linked Lists', 'Trees', 'Tries', 'Heap / Priority Queue', 'Backtracking', '1-D DP', '2-D DP', 'Graphs', 'Advanced Graphs'];
const PATTERNS  = ['Hash Map', 'Hash Set', 'Two Pointers', 'Fast / Slow', 'Sliding Window', 'Stack', 'Binary Search', 'DFS', 'BFS', 'Topological Sort', 'Dynamic Prog.', 'Greedy', 'Backtracking', 'Two Heaps', 'Divide & Conquer', 'Kadane', 'Bit Manipulation'];
const SOURCES   = ['All', 'Striver A2Z', 'NeetCode 150', 'Blind 75', 'Grind 75', 'LC Top 150', 'AlgoExpert', 'Codeforces', 'GFG Must-Do'];

/* ── Heatmap (deterministic, 371 cells = 53 weeks × 7 days) ─ */
function buildHeatmap() {
  const cells = [];
  let seed = 9301;
  const rnd = () => { seed = (seed * 9301 + 49297) % 233280; return seed / 233280; };
  for (let i = 0; i < 371; i++) {
    const recency = i / 371;
    let v = 0;
    const roll = rnd() * (0.45 + recency * 0.85);
    if (roll > 0.78)      v = 3;
    else if (roll > 0.55) v = 2;
    else if (roll > 0.3)  v = 1;
    if (rnd() < 0.18)     v = 0;
    cells.push(v);
  }
  return cells;
}
const HEATMAP = buildHeatmap();

Object.assign(window, {
  PROBLEMS, ROADMAP, STRIVER_SECTIONS, REVIEW_QUEUE, PROBLEM_DETAIL,
  MASTERY, CHEATSHEETS, CATALOG,
  PLATFORMS, TOPICS, PATTERNS, SOURCES, HEATMAP,
});
