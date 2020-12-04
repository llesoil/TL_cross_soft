#!/bin/sh

numb='2868'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 35 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.0,1.2,4.4,0.5,0.6,0.4,2,2,8,35,200,0,30,10,4,4,69,28,6,2000,1:1,umh,crop,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"