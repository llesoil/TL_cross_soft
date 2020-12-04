#!/bin/sh

numb='597'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 25 --keyint 260 --lookahead-threads 3 --min-keyint 20 --qp 50 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.4,1.6,0.5,0.8,0.7,3,0,16,25,260,3,20,50,4,1,64,38,6,1000,1:1,dia,crop,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"