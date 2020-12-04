#!/bin/sh

numb='2407'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 35 --keyint 270 --lookahead-threads 2 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.6,1.3,4.8,0.2,0.7,0.0,2,1,4,35,270,2,27,40,3,2,62,28,5,2000,-2:-2,umh,crop,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"