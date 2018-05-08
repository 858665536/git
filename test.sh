
##########初始化默认值##########
#iOS工程路径
iOS_project_base_dir=""
this_script_file_path=""
uploadMessage="update"
gitTagLongNumber=""
appDisplayName=""
web_project_Dir=""


ios_project_full_path=""
upload_message="update"
schema_name=""

#后面带冒号，说明需要带参数
param_pattern=":m:f:"
while getopts $param_pattern optname
  do
    #保存临时变量
    tmp_optind=$OPTIND
    tmp_optname=$optname
    tmp_optarg=$OPTARG

    #对参数进行检查
    OPTIND=$OPTIND-1
    if getopts $param_pattern optname ;then
      echo $param_pattern
      echo  "Error: argument value for option $tmp_optname"
      usage
      exit 2
    fi

    #恢复变量
    OPTIND=$tmp_optind
    optname=$tmp_optname

    case "$optname" in
      "m")
        upload_message=$tmp_optarg
              echo $upload_message

            ;;
    "f")
        ios_project_full_path=$tmp_optarg;
        echo $ios_project_full_path


string="/Users/admin/workspace/ds-quanzi-ios/JFCircle.xcworkspace"
set -f                      # avoid globbing (expansion of *).
pwdArray=(${string//// })
lastComponnt=${pwdArray[@]:(-1)}
echo $lastComponnt

schemeArray=(${lastComponnt//./ })

schema_name=${schemeArray[0]}

echo $schema_name

full_path_size=${#string} 

lastComponnt_size=${#lastComponnt} 



iOS_project_base_dir="${string:0:full_path_size-lastComponnt_size}"
echo "${iOS_project_base_dir}"


        ;;            
    esac
  done


  autoBuildIpa () 
{
#pod install --no-repo-update --verbose
  # 我们是使用前时间作为build号的 2016041517 即为16年4月15号17点
version_string=$(date +%Y%m%d%H%M)

# 下面是一些用到的变量给抽取出来了
# 工程环境路径
workspace_path=${PWD}/JFCircle

# 打包项目名字
scheme_name=JFCircle

# 打包使用的证书 
# CODE_SIGN_IDENTITY="iPhone Distribution: GanSu Homepay Electronic Tec. Co.,Ltd. (4LVL97DH97)"
CODE_SIGN_IDENTITY="iPhone Distribution: Zhejiang Jfpal financial data processing Co., Ltd. (89Z2LB5J7R)"
# 打包使用的描述文件 这描述文件的名字不是自己命名的那个名字，而是对应的8b11ac11-xxxx-xxxx-xxxx-b022665db452这个名字
# PROVISIONING_PROFILE="5a8af20d-32ca-4e0d-a571-08299c5c2f81"
PROVISIONING_PROFILE_SPECIFIER="777f1ad8-9e51-4d55-97c7-a79683f442e1"

# 指定JFCircle.app的输出位置 也就是Demo中build文件夹的位置
# 清空上一次的文件夹
rm -rf ~/Desktop/project

# 创建要工作的文件夹
mkdir ~/Desktop/project

build_path=~/Desktop/project/build

# 指定JFCircle.ipa的输出位置
ipa_path=~/Desktop/project

# writeMessageToVersionFile

gitTagLongNumber=`git rev-parse HEAD`


# 生成JFCircle.app, 在build_path路径下面


xcodebuild clean -project ${workspace_path}.xcworkspace -configuration Release -alltargets

xcodebuild -workspace ${workspace_path}.xcworkspace -scheme ${scheme_name} -configuration Release clean -sdk iphoneos build CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${PROVISIONING_PROFILE}" SYMROOT="${build_path}"



# 生成JFCircle.ipa, 在ipa_path路径下面
xcrun -sdk iphoneos -v PackageApplication ${build_path}/Release-iphoneos/JFCircle.app -o ${ipa_path}/JFCircle_ios_${version_string}.ipa


rm -rf ${build_path}
# .ipa文件的位置
ipa_file_path=~/Desktop/project/JFCircle_ios_${version_string}.ipa


echo "ipa文件的位置 ${ipa_file_path}"
#.ipa文件所在的文件夹
#
#echo "拷贝 embedded.mobileprovision  entitlements.plist到 ${ipa_path}"
#cp ${this_script_file_path}/embedded.mobileprovision ${ipa_path}
#
#cp ${this_script_file_path}/entitlements.plist ${ipa_path}
cp ${this_script_file_path}/JSON.sh ${ipa_path}
echo "拷贝 完成"


ipa_file_name=JFCircle_ios_${version_string}.ipa

#echo "开始重签名${ipa_file_name}"

cd ${ipa_path}

echo "now path is : ${PWD}"
echo "ipa_file_path ${ipa_file_name},ipa完整路径是${ipa_file_path}"
#resignIpa ${ipa_file_name} ${ipa_file_path}

# uploadToFir ${ipa_file_name} ${ipa_file_path}
}
