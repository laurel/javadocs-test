echo 
echo "This script builds the pipeline Javadocs for Fusion 5+."
echo 
echo "You must run the script from 'static/fusion-pipeline-javadocs'! If you are running the script from a different folder, cancel now and restart at the right folder."

# REQUIRED IMPROVEMENTS
# A check for Java version should be made. 


# REQUIRED IMPROVEMENTS
# The versions for pipeline, chassis, and searchdsl should be entered manually. 
# A check for Java version should be made. 

if [ $# -le 2 ]
then

# Create a variable for the target Fusion version.
    echo
    echo "What Fusion version are you targeting? For example: 5.11.0 "
    echo
    read version
    fusionVersion=$version

# Create another variable for the Javadocs version.
    javadocsVersion="5.11"

# Create another variable for the Javadocs directory.
    javadocsPath="$(pwd)"

# Confirm the operation with the user.
    pipelineDir=$javadocsPath/$javadocsVersion
    echo
    echo "Fetching Javadocs for Fusion $fusionVersion and dropping them in: $pipelineDir"
    echo
    echo "Would you like to continue? y/n"
    echo
    read response
    if [ $response = 'n' ]
    then
        echo
        echo "Exiting now."
        exit 1
    fi
    echo
    echo "Starting..."
    echo
fi

# Create a temporary folder, 'tempJavadocs', to contain the 'fusion-indexing' and 'fusion-query' repos.
    mkdir -p $pipelineDir

# The versions for pipeline, chassis, and searchdsl should be entered manually.

    fusionPipelineVersion="FUS-4268-javadocs"
    indexVersion="releases/5.10.x"
    queryVersion="releases/5.10.x"
    chassisVersion="release/6.3.x"
    searchDslVersion="release/6.x"

    echo "javadocsVersion: $javadocsVersion"
    echo "fusionPipelineVersion: $fusionPipelineVersion"
    echo "indexVersion: $indexVersion"
    echo "queryVersion: $queryVersion"
    echo "chassisVersion: $chassisVersion"
    echo "searchDslVersion: $searchDslVersion"
    echo

    read -p "Press any key to continue with these version variables... " -n1 -s
    echo

    mkdir tempJavadocs
    cd tempJavadocs

# Clone the 'fusion-pipelines' repo and checkout the correct version.
    echo
    git clone https://github.com/lucidworks/fusion-pipelines.git
    cd fusion-pipelines
    git checkout $fusionPipelineVersion
    git pull origin $fusionPipelineVersion
    ./gradlew fusion-base-pipeline::classes

# Clone the 'fusion-indexing' repo and checkout the correct version.
    echo
    cd ..
    git clone https://github.com/lucidworks/fusion-indexing.git
    cd fusion-indexing
    git checkout $indexVersion

# Clone the 'fusion-query' repo and checkout the correct version.
    echo
    cd ..
    git clone https://github.com/lucidworks/fusion-query.git
    cd fusion-query
    git checkout $queryVersion
    ./gradlew query-pipeline::classes

# Clone the 'fusion-chassis' repo and checkout the correct version.
    echo
    cd ..
    git clone https://github.com/lucidworks/fusion-chassis.git
    cd fusion-chassis
    git checkout $chassisVersion
    ./gradlew classes

# Clone the 'search-dsl' repo and checkout the correct version.
    echo
    cd ..
    git clone https://github.com/lucidworks/search-dsl.git
    cd search-dsl
    git checkout $searchDslVersion

    read -p "Done cloning. Press any key to continue... " -n1 -s

# Go back to the base folder.
    echo 
    cd ../../
# Generate the javadocs in build/docs/javadoc
    echo 
    ./gradlew -Pversion=$javadocsVersion clean javadoc 

    read -p "Generated Javadocs. Press any key to continue... " -n1 -s

    #rm -r $pipelineDir
    cp -R build/docs/javadoc/* $pipelineDir/

    read -p "Copied over the Javadocs. Press any key to continue... " -n1 -s

 # Delete the 'tempJavadocs' folder.
    echo 
    echo "Deleting the temporary repo folder."
    rm -rf tempJavadocs

    read -p "Deleted the temporary Javadocs directory. Press any key to continue... " -n1 -s

# Notify that the script has completed.
    echo 
    echo "Done. Check $pipelineDir to verify the script succeeded."
