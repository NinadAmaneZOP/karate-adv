function fn() {
  return {
    randomNumber: function(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; },
    randomString: function(len) { return Math.random().toString(36).substring(2, 2 + len); },
    randomItem: function(arr) { return arr[Math.floor(Math.random() * arr.length)]; },
    sum: function(arr) { var t = 0; for (var i = 0; i < arr.length; i++) t += Number(arr[i]); return t; },
    isUnique: function(arr) { var s = {}; for (var i = 0; i < arr.length; i++) { if (s[arr[i]]) return false; s[arr[i]] = true; } return true; },
    formatDate: function(d) { return d.toISOString().split('T')[0]; },
    addDays: function(d, days) { var r = new Date(d.getTime()); r.setDate(r.getDate() + days); return r; },
    isSortedAsc: function(arr) { for (var i = 1; i < arr.length; i++) { if (arr[i - 1] > arr[i]) return false; } return true; },
    isSortedDesc: function(arr) { for (var i = 1; i < arr.length; i++) { if (arr[i - 1] < arr[i]) return false; } return true; },
    getProductParams: function() { return { limit: 15 }; },
    getSortedParams: function() { return { limit: 10, sortBy: 'price', order: 'asc' }; },
    getSortedRatingDescParams: function() { return { limit: 10, sortBy: 'rating', order: 'desc' }; },
    getPaginationParams: function() { return { limit: 5, skip: 10 }; },
    getSelectParams: function() { return { limit: 5, select: 'title,price' }; },
    getCategoryName: function() { return 'beauty'; }
  };
}
