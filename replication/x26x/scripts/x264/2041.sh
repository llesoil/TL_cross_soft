#!/bin/sh

numb='2042'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --intra-refresh --no-asm --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 1.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 20 --keyint 210 --lookahead-threads 4 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,--no-asm,None,--weightb,2.0,1.5,1.1,1.0,0.6,0.7,0.2,1,1,2,20,210,4,22,50,5,2,61,38,1,2000,-1:-1,umh,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"