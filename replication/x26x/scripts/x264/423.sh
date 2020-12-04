#!/bin/sh

numb='424'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 5 --keyint 230 --lookahead-threads 2 --min-keyint 20 --qp 50 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.4,1.2,4.6,0.3,0.7,0.9,3,2,6,5,230,2,20,50,3,2,65,38,5,1000,1:1,hex,show,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"