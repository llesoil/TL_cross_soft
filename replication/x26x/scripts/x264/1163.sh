#!/bin/sh

numb='1164'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 0 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.0,1.1,3.6,0.3,0.8,0.5,2,0,8,0,230,0,23,50,5,1,65,28,2,1000,-2:-2,umh,crop,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"