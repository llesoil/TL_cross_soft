#!/bin/sh

numb='104'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 45 --keyint 200 --lookahead-threads 2 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.5,1.5,1.3,3.4,0.4,0.8,0.3,1,2,10,45,200,2,25,10,5,1,63,18,4,1000,-1:-1,dia,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"