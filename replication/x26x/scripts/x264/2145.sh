#!/bin/sh

numb='2146'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 35 --keyint 250 --lookahead-threads 3 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.0,1.0,1.4,3.8,0.6,0.9,0.8,3,1,16,35,250,3,23,10,4,1,67,28,3,2000,-1:-1,dia,show,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"