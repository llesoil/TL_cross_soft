#!/bin/sh

numb='2473'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 45 --keyint 290 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.5,1.0,1.4,4.6,0.2,0.9,0.7,1,1,16,45,290,4,27,40,5,0,68,28,6,2000,-2:-2,dia,crop,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"