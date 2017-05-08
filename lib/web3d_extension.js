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