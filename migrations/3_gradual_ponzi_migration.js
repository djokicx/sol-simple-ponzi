var gradualPonzi = artifacts.require("GradualPonzi");

module.exports = function(deployer) {
    deployer.deploy(gradualPonzi);
};