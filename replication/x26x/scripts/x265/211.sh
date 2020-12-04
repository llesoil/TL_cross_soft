#!/bin/sh

numb='212'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 3.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 25 --keyint 260 --lookahead-threads 0 --min-keyint 20 --qp 20 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.4,1.4,3.0,0.4,0.6,0.0,1,2,16,25,260,0,20,20,5,3,65,48,6,2000,-2:-2,dia,crop,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"