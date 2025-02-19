const fs = require('fs');

function parseLcov(content) {
    const coverage = new Map();
    let currentFile = null;
    let currentMetrics = null;

    content.split('\n').forEach(line => {
        if (line.startsWith('SF:')) {
            currentFile = line.substring(3);
            currentMetrics = { functions: 0, lines: 0, branches: 0 };
            coverage.set(currentFile, currentMetrics);
        } else if (currentMetrics) {
            if (line.startsWith('FNH:')) {
                currentMetrics.functions = parseInt(line.split(':')[1]) || 0;
            } else if (line.startsWith('LH:')) {
                currentMetrics.lines = parseInt(line.split(':')[1]) || 0;
            } else if (line.startsWith('BRH:')) {
                currentMetrics.branches = parseInt(line.split(':')[1]) || 0;
            }
        }
    });

    return coverage;
}

function compareCoverage(mainLcovPath, branchLcovPath) {
    const mainContent = fs.readFileSync(mainLcovPath, 'utf8');
    const branchContent = fs.readFileSync(branchLcovPath, 'utf8');

    const mainCoverage = parseLcov(mainContent);
    const branchCoverage = parseLcov(branchContent);

    const decreases = [];

    branchCoverage.forEach((branchMetrics, file) => {
        const mainMetrics = mainCoverage.get(file);
        if (!mainMetrics) return; // Skip new files

        const decrease = {
            file,
            metrics: {}
        };

        let hasDecrease = false;

        ['functions', 'lines', 'branches'].forEach(metric => {
            if (branchMetrics[metric] < mainMetrics[metric]) {
                hasDecrease = true;
                decrease.metrics[metric] = {
                    from: mainMetrics[metric],
                    to: branchMetrics[metric],
                    decrease: mainMetrics[metric] - branchMetrics[metric]
                };
            }
        });

        if (hasDecrease) {
            decreases.push(decrease);
        }
    });

    return decreases;
}

const mainLcovPath = process.argv[2] || 'lcov-main.info';
const branchLcovPath = process.argv[3] || 'lcov.info';

try {
    const decreases = compareCoverage(mainLcovPath, branchLcovPath);

    if (decreases.length === 0) {
        console.log('✅ No coverage decreases found');
    } else {
        console.log('🔍 Found coverage decreases in these files:\n');
        decreases.forEach(({ file, metrics }) => {
            console.log(`📁 ${file}`);
            Object.entries(metrics).forEach(([metric, values]) => {
                console.log(`  ${metric}: ${values.from} → ${values.to} (decrease of ${values.decrease})`);
            });
            console.log('');
        });
    }
} catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
}