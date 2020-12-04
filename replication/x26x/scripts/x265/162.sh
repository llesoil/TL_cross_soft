#!/bin/sh

numb='163'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 5.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 35 --keyint 260 --lookahead-threads 3 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.0,1.2,5.0,0.3,0.9,0.0,1,1,10,35,260,3,21,40,4,4,64,28,2,2000,-2:-2,dia,show,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"