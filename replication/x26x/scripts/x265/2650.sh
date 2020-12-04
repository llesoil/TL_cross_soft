#!/bin/sh

numb='2651'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 45 --keyint 300 --lookahead-threads 4 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.0,1.3,4.6,0.6,0.8,0.7,1,2,8,45,300,4,21,10,4,3,65,38,4,2000,-1:-1,umh,crop,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"