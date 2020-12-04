#!/bin/sh

numb='522'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 2.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 30 --keyint 290 --lookahead-threads 2 --min-keyint 25 --qp 30 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.2,1.1,2.8,0.2,0.8,0.0,0,2,0,30,290,2,25,30,4,3,61,48,2,1000,-2:-2,hex,show,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"