define(["require",
        "../../deps/lib/d3.v3.min.js",
        "../../deps/lib/vega.min.js",
        "../../deps/lib/vega-lite.min.js",
        "../../deps/lib/vega-embed.min.js"],
  function(require, d3, vg, vl, vg_embed) {

  //   requirejs.config({
  //       paths: {
  //         d3: "https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.16/d3.min.js?noext",
  //         vg: "https://cdnjs.cloudflare.com/ajax/libs/vega/2.5.1/vega.min.js?noext",
  //         vl: "https://vega.github.io/vega-lite/vega-lite.js?noext",
  //         vg_embed: "https://vega.github.io/vega-editor/vendor/vega-embed.js?noext"
  //       },
  //       shim: {
  //         vg_embed: {deps: ["vg.global", "vl.global"]},
  //         vl: {deps: ["vg"]},
  //         vg: {deps: ["d3"]}
  //       }
  //   });

  define('vg.global', ['vg'], function(vgGlobal) {
      window.vg = vgGlobal;
  });

  define('vl.global', ['vl'], function(vlGlobal) {
      window.vl = vlGlobal;
  });



  return {

    props: ['params', 'nid', 'deco'],

    // render: function(createElement) {
    //   var html = katex.renderToString(this.params.expr,
    //                                   this.params.options);
    //   console.log('rendering katex');
    //   return createElement('span', { domProps: { innerHTML: html } })
    // }

    render: function(createElement) {

      var opt = {
        mode: "vega-lite",
        renderer: this.params.renderer,
        actions: this.params.actions
      }

      console.log("vegalite renderer : " + this.params.renderer)
      console.log("vegalite actions : " + this.params.actions)
      console.log("vegalite spec : " + this.params.spec)

      vg.embed(this.$el, this.params.spec, opt);
    }


  }

} )
