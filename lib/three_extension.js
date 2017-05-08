/**
 * Created by maliut on 2017/5/8.
 */
// this lib must be added after Three.js
window.THREEx = window.THREEx || {};

// skybox
THREEx.makeSkyBox = function (urls, size) {
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