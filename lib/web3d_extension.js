/**
 * Created by maliut on 2017/5/8.
 */
// this lib must be added after Three.js

// add skybox support for three.js
THREE.SkyBox = function (urls, size) {
    var skyboxCubemap = new THREE.CubeTextureLoader().load(urls);
    skyboxCubemap.format = THREE.RGBFormat;

    var skyboxShader = THREE.ShaderLib['cube'];
    skyboxShader.uniforms['tCube'].value = skyboxCubemap;

    return new THREE.Mesh(
        new THREE.BoxGeometry(size, size, size),
        new THREE.ShaderMaterial({
            fragmentShader : skyboxShader.fragmentShader,
            vertexShader : skyboxShader.vertexShader,
            uniforms : skyboxShader.uniforms,
            depthWrite : false,
            side : THREE.BackSide
        })
    );
};

// add text sprite support
THREE.TextSprite = function (message, parameters) {
    if (parameters === undefined) parameters = {};
    var fontface = parameters.hasOwnProperty("fontface") ? parameters["fontface"] : "Arial";
    var fontsize = parameters.hasOwnProperty("fontsize") ? parameters["fontsize"] : 8;
    var borderThickness = parameters.hasOwnProperty("borderThickness") ? parameters["borderThickness"] : 4;
    var textColor = parameters.hasOwnProperty("textColor") ?parameters["textColor"] : { r:0, g:0, b:0, a:1.0 };

    var canvas = document.createElement('canvas');
    var context = canvas.getContext('2d');
    context.font = "Bold " + fontsize + "px " + fontface;
    //var metrics = context.measureText( message );
    //var textWidth = metrics.width;

    context.lineWidth = borderThickness;
    context.fillStyle = "rgba("+textColor.r+", "+textColor.g+", "+textColor.b+", 1.0)";
    context.fillText(message, borderThickness, fontsize + borderThickness);

    var texture = new THREE.Texture(canvas);
    texture.needsUpdate = true;

    var spriteMaterial = new THREE.SpriteMaterial({map: texture/*, useScreenCoordinates: false*/});
    var sprite = new THREE.Sprite(spriteMaterial);
    sprite.scale.set(0.5 * fontsize, 0.25 * fontsize, 0.75 * fontsize);
    return sprite;
};

// add function to define getter & setter for property
Function.prototype.property = function(prop, desc) {
    return Object.defineProperty(this.prototype, prop, desc);
};

// add function to remove an element from array
Array.prototype.indexOf = function(val) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] === val) return i;
    }
    return -1;
};

Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};