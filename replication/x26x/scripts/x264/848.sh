#!/bin/sh

numb='849'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 50 --keyint 300 --lookahead-threads 1 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.3,1.0,4.6,0.6,0.7,0.6,3,2,12,50,300,1,30,40,3,2,62,48,5,2000,1:1,umh,show,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"