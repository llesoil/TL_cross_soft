#!/bin/sh

numb='190'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 35 --keyint 220 --lookahead-threads 3 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.0,1.2,4.4,0.4,0.9,0.9,2,1,14,35,220,3,24,40,4,2,60,28,6,1000,1:1,umh,show,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"