#!/bin/sh

numb='2763'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 20 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.0,1.0,1.4,0.4,0.9,0.6,3,1,4,20,200,1,27,10,4,1,67,28,2,2000,-1:-1,hex,show,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"