#!/bin/sh

numb='1356'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 25 --keyint 230 --lookahead-threads 2 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.0,1.2,2.2,0.6,0.8,0.3,1,1,8,25,230,2,20,40,3,4,60,38,6,2000,-1:-1,dia,show,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"