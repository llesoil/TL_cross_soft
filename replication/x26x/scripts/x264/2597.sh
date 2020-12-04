#!/bin/sh

numb='2598'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 25 --keyint 290 --lookahead-threads 2 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.5,1.4,1.4,0.4,0.7,0.9,3,1,14,25,290,2,20,50,5,1,67,48,2,2000,1:1,umh,show,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"