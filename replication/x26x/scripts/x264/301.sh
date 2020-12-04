#!/bin/sh

numb='302'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 1.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 10 --keyint 250 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.5,1.6,1.4,1.6,0.4,0.6,0.8,0,2,10,10,250,0,21,30,3,1,60,38,5,1000,-1:-1,hex,show,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"