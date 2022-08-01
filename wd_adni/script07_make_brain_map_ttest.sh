#!/bin/sh
# run bash **.sh rather than sh **.sh in case of error may occur or weird things
# with for loop, awk, etc..

#atlas_dir="aal"
atlas_file="/home/xin/Downloads/DPABI_V6.1_220101/Templates/Power_Neuron_264ROIs_Radius5_Mask.nii"
out_dir="/home/xin/Downloads/Harmonics/make_brain_map/"

file_name="adni_out05_ttest/lasso_stats_CN_AD.csv"
out_img_name="brain_map_stats_cn_ad"

#file_name="adni_out05_lasso/lasso_coefs_CN_LMCI.csv"
#out_img_name="adni_out07_brain_map/brain_map_cn_lmci"
#
#file_name="adni_out05_lasso/lasso_coefs_CN_EMCI.csv"
#out_img_name="adni_out07_brain_map/brain_map_cn_emci"

# use bash in stead of sh to make for loop work properly.
for col in {2..11};
do

freq=$(expr $col - 1)
## create empty .nii file:
fslmaths $atlas_file -mul 0 ${out_dir}${out_img_name}_freq${freq}

# read the 1st and ith column of file:
# skip first 1 row (header)
# tr -d delete specific characters in the file.
# '\15': shift in
# '\32': space

cat $file_name | awk -v c=$col -F ',' 'NR > 3 {print $1, $c}' | while IFS=' ' read idx value; 
## seems tr -d is unnecessary, we just need to set IFS=' ', instead of ','.
#tr -d '\15\32' < $file_name | awk -v c=$col -F ',' 'NR > 1 {print $1, $c}' | while IFS=' ' read idx value; 
do 
    # remove first 3 char ('roi'):
    idx="${idx:3}"

	echo $idx
	echo $value

	fslmaths $atlas_file -thr $idx -uthr $idx -bin temp.nii.gz
	fslmaths temp.nii.gz -mul $value -add ${out_dir}${out_img_name}_freq${freq} ${out_dir}${out_img_name}_freq${freq}
done
done

#rm temp.nii.gz
