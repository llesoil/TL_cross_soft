#!/bin/sh

numb='541'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --intra-refresh --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 25 --keyint 220 --lookahead-threads 0 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,--no-asm,--slow-firstpass,--no-weightb,2.5,1.1,1.4,0.8,0.3,0.7,0.6,0,1,16,25,220,0,23,20,5,0,66,28,1,2000,-2:-2,dia,show,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"