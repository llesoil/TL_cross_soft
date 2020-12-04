#!/bin/sh

numb='2320'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 15 --keyint 220 --lookahead-threads 2 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.5,1.2,1.3,1.4,0.6,0.8,0.4,1,2,8,15,220,2,20,40,3,4,61,18,6,2000,-1:-1,hex,show,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"