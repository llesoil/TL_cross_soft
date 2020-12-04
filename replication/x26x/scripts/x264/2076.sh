#!/bin/sh

numb='2077'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 20 --keyint 280 --lookahead-threads 0 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.0,1.0,1.3,1.4,0.3,0.7,0.9,2,0,16,20,280,0,23,50,5,2,67,18,3,1000,1:1,hex,crop,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"