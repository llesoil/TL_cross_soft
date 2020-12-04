#!/bin/sh

numb='1512'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 25 --keyint 210 --lookahead-threads 1 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.2,1.0,4.2,0.4,0.8,0.8,3,1,12,25,210,1,22,20,3,2,67,48,5,2000,-2:-2,umh,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"