exports.dslize = function(kls, stmts) {
  Object.keys(stmts).forEach(function(key){
    const def = stmts[key]
    kls.__proto__["get_" + key] = function() {
      this[key] || def;
    };
    kls.__proto__["set_" + key] = function(v) {
      this[key] = v;
    };
  });
};
