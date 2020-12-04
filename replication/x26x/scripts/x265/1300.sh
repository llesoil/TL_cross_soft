#!/bin/sh

numb='1301'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 25 --keyint 230 --lookahead-threads 1 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.6,1.0,4.6,0.2,0.7,0.3,3,1,14,25,230,1,21,10,3,2,64,18,3,2000,-2:-2,umh,crop,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"