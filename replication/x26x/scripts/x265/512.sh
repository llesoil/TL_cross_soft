#!/bin/sh

numb='513'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 15 --keyint 290 --lookahead-threads 3 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.4,1.0,0.6,0.5,0.9,0.5,0,1,0,15,290,3,21,0,4,2,65,48,3,1000,-2:-2,hex,show,ultrafast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"