#!/bin/sh

numb='1816'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 20 --keyint 230 --lookahead-threads 3 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.2,1.3,1.2,0.3,0.8,0.9,3,0,12,20,230,3,30,50,5,0,62,38,5,1000,-2:-2,hex,show,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"