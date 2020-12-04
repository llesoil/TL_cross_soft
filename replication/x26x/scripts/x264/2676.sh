#!/bin/sh

numb='2677'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 0 --keyint 260 --lookahead-threads 0 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.1,1.0,5.0,0.4,0.8,0.3,1,0,2,0,260,0,29,40,4,2,61,18,6,1000,-1:-1,hex,show,superfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"